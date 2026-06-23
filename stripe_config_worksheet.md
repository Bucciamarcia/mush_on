# Stripe Account Archival, Reconnection & Live/Test Toggle — Implementation Worksheet

This document plus the test suites below are a complete, self-contained spec.
Implement until every listed test passes.

**Test suites (the executable spec):**

- `functions/test_stripe_accounts_overhaul.py` — backend logic (Python Cloud Functions).
- `test/settings/stripe_accounts_overhaul_test.dart` — Flutter models, repository, pure selectors.
- `test/settings/stripe_accounts_widgets_test.dart` — Flutter settings UI.

Run them with:

```bash
cd functions && python -m unittest test_stripe_accounts_overhaul        # backend
flutter test test/settings/stripe_accounts_overhaul_test.dart           # dart logic
flutter test test/settings/stripe_accounts_widgets_test.dart            # dart UI
```

> A handful of the Python tests already pass today because the legacy code
> happens to produce the right outcome (e.g. "rejects when no connected
> account"). They are regression guards — keep them green through the refactor.
> Everything else fails today and must be made to pass.

---

## 1. The problem we are solving

Today, disconnecting Stripe **deletes** the stored account id
(`_disconnect_active_stripe_connection` pops the mode key from
`accounts/{account}/integrations/stripe`). If a user disconnects by accident,
the account id is gone forever. We also have no first-class Live/Test switch in
the UI (it is implicitly driven by a stored `activeMode`).

**Goal:** never destroy connection history on disconnect; keep every previously
connected account as *archived*; let the user reconnect a previous account, and
explicitly switch between Live and Test mode. Deleting an archived account is
the only destructive action, gated behind a prominent warning.

The user-visible *effect* of disconnect is unchanged (checkout stops). Only the
storage changes (archive instead of delete).

---

## 2. Target Firestore data model

### Parent document — `accounts/{account}/integrations/stripe`

```jsonc
{
  "selectedMode": "test" | "live"   // persisted Live/Test toggle (drives the UI)
}
```

`onboardingAttempts` subcollection stays exactly as it is today.

> Legacy fields (`test`, `live`, `activeMode`, flat `accountId`/`isActive`) are
> replaced. See §7 for migration.

### Per-account subcollection — `accounts/{account}/integrations/stripe/accounts/{stripeAccountId}`

The **document id is the Stripe account id** (`acct_...`). This prevents
duplicates and is human-traceable.

```jsonc
{
  "accountId":   "acct_xxx",          // == document id
  "mode":        "test" | "live",
  "archived":    false,               // false == currently connected
  "isActive":    true,                // USER intent to accept payments
  "connectedAt": <Timestamp>,
  "archivedAt":  <Timestamp|null>
}
```

### Invariants

1. **At most one** document per `mode` has `archived == false` (the "connected"
   account). Any number may be `archived == true` (history).
2. `archived` and `isActive` are **independent** and mean different things:
   - `archived` = connection lifecycle. `false` → this is the account in use for
     that mode. `true` → previously used, retained so it can be reconnected.
   - `isActive` = the **user's choice** to have payments switched on, even when a
     Stripe account is connected. It is **not** Stripe charges-readiness.
3. Stripe charges-readiness stays a **live-fetched** concept, surfaced through
   `get_stripe_connection_status` / `StripeConnectionStatus` (`chargesEnabled`,
   `isReady`, …). It is never persisted as the source of truth.

### Checkout gating (new rule)

Checkout for a booking is allowed only when, for `selectedMode`:
the connected account exists (`archived == false`) **and** `isActive == true`
**and** Stripe reports it can charge (`_verify_connected_account_can_charge`).

---

## 3. Backend (`functions/main.py` + `functions/lib/stripe/utils.py`)

### 3.1 New / changed resolver helpers (`utils.py`)

Replace the map-field readers with subcollection readers. Suggested signatures:

```python
def get_selected_stripe_mode(account: str) -> str:
    """Read selectedMode from the parent doc; default 'test'."""

def get_connected_account_doc(account: str, stripe_mode: str) -> dict | None:
    """Query accounts/{account}/integrations/stripe/accounts where
    mode == stripe_mode and archived == False. Return its dict (incl. accountId)
    or None. There must be at most one."""

def get_account_doc(account: str, account_id: str) -> dict | None:
    """Read a single subcollection doc by id."""
```

Keep `normalize_stripe_mode`, `get_stripe_api_key`, `get_checkout_stripe_api_key`.
`get_active_mode_connection` callers (`create_checkout_session`,
`create_booking_checkout_session`, `_stripe_connection_status`,
`get_public_stripe_status`, refund readers) must be rewired to use
`get_connected_account_doc(account, get_selected_stripe_mode(account))`.

Helper to write/flip a single account doc, e.g.:

```python
def _account_ref(db, account, account_id):
    return db.document(
        f"accounts/{account}/integrations/stripe/accounts/{account_id}"
    )

def _archive_connected_account(db, account, stripe_mode):
    """Set archived=True + archivedAt on the current connected doc, if any."""
```

### 3.2 Callable changes

| Callable | Change |
|---|---|
| `stripe_create_account` | After `stripe.Account.create`, **archive** any existing connected account for that mode, then write a new subcollection doc `{accountId, mode, archived:false, isActive:false, connectedAt: now, archivedAt: null}`. Still returns `{"account": acct.id}`. |
| `disconnect_stripe_account` | Accept `stripeMode` in `data` (fallback to `selectedMode`). Instead of popping, set the connected doc `archived=true, archivedAt=now`. If none connected → `FAILED_PRECONDITION`. Returns `{"activeMode": stripe_mode}` (or similar). |
| `reconnect_stripe_account` **(new)** | `data: {account, accountId, stripeMode}`. If target doc missing → `NOT_FOUND`. Archive the currently connected doc for that mode, then set the target doc `archived=false, archivedAt=null`. Membership required. |
| `delete_stripe_account` **(new)** | `data: {account, accountId}`. If the target doc has `archived == false` → `FAILED_PRECONDITION` (must disconnect first). Otherwise hard-`delete()` the doc. **No Stripe API call.** Membership required. |
| `set_selected_stripe_mode` **(new)** | `data: {account, stripeMode}`. `merge`-write `selectedMode` on the parent doc. Membership required. |
| `change_stripe_integration_activation` | Flip `isActive` on the **connected** doc for the given mode. If none connected → `FAILED_PRECONDITION`. Does not touch `archived`. |
| `finalize_stripe_onboarding` | Update the connected subcollection doc for the attempt's account: set `isActive = charges_enabled` (default-activate on a successful, charges-enabled onboarding), keep `archived=false`. Keep the existing attempt token/expiry/consume checks. |
| `get_stripe_connection_status` | Read the connected doc for `selectedMode`; `hasAccount=False` when only archived docs exist. `activeMode` in the response = `selectedMode`. |
| `get_public_stripe_status` | Same resolver; return `{activeMode, isActive}`; **never** include `accountId`. |

All new callables guard with `_assert_account_member`.

### 3.3 Security rules

If the Flutter `selectedMode`/`stripeAccounts` streams read these docs directly
(they do — see §4), ensure `firestore.rules` lets account members **read**
`accounts/{account}/integrations/stripe` and its `accounts` subcollection, while
**writes** remain callable-only. (Account ids in test mode are not secret, but
keep writes server-side.)

---

## 4. Flutter

### 4.1 Models — `lib/settings/stripe/stripe_models.dart`

Add a freezed `StripeAccount` (one subcollection doc):

```dart
@freezed
sealed class StripeAccount with _$StripeAccount {
  const factory StripeAccount({
    required String accountId,
    required StripeMode mode,
    @Default(false) bool archived,
    @Default(false) bool isActive,
    @TimestampConverter() DateTime? connectedAt,
    @TimestampConverter() DateTime? archivedAt,
  }) = _StripeAccount;

  factory StripeAccount.fromJson(Map<String, dynamic> json) =>
      _$StripeAccountFromJson(json);
}
```

`StripeMode` enum and `StripeConnectionStatus` stay. The old `StripeConnection`
/ `StripeModeConnection` can be removed once nothing references them (the legacy
`stripeConnectionProvider` and `stripe_payment_settings.dart` are rewritten).
Run `dart run build_runner build` to regenerate `.freezed.dart`/`.g.dart`.

### 4.2 Pure selectors — `lib/settings/stripe/stripe_account_selectors.dart` (new)

```dart
StripeAccount? connectedAccountForMode(List<StripeAccount> accounts, StripeMode mode) =>
    accounts.where((a) => a.mode == mode && !a.archived).firstOrNull;

List<StripeAccount> archivedAccountsForMode(List<StripeAccount> accounts, StripeMode mode) =>
    accounts.where((a) => a.mode == mode && a.archived).toList();
```

### 4.3 Repository — `lib/settings/stripe/stripe_repository.dart`

Add (matching the payloads asserted in the dart logic test):

```dart
Future<void> setSelectedMode(StripeMode mode);                 // -> set_selected_stripe_mode {account, stripeMode}
Future<void> reconnectStripeAccount({required String accountId, required StripeMode stripeMode}); // -> reconnect_stripe_account
Future<void> deleteStripeAccount({required String accountId}); // -> delete_stripe_account {account, accountId}
Future<void> disconnectStripeAccount({required StripeMode stripeMode}); // -> disconnect_stripe_account {account, stripeMode}

Stream<StripeMode> selectedMode();           // reads parent doc selectedMode (default test)
Stream<List<StripeAccount>> stripeAccounts({StripeMode? mode}); // reads the accounts subcollection
```

Keep `createStripeAccount`, `createStripeAccountLink`, `getStripeConnectionStatus`,
`changeStripeIntegrationActivation`. The old `disconnectActiveStripeConnection`
may be kept as a thin wrapper or removed. All callable methods follow the
existing pattern: unwrap `data`, throw on non-null `error`.

### 4.4 Providers — `lib/settings/stripe/riverpod.dart`

```dart
@riverpod
Stream<StripeMode> selectedStripeMode(Ref ref);            // parent doc selectedMode

@riverpod
Stream<List<StripeAccount>> stripeAccounts(Ref ref);       // subcollection
```

Both resolve `account` via `accountProvider`. Derive connected/archived in the
widget with the §4.2 selectors (or add thin derived providers). Remove the old
`stripeConnectionProvider` once unused.

### 4.5 UI — `lib/settings/stripe/stripe_payment_settings.dart`

`PaymentSettingsWidget` watches `selectedStripeModeProvider` and
`stripeAccountsProvider`. Required widgets / copy (asserted by the widget test):

1. **Mode toggle** at the top: `SegmentedButton<StripeMode>` with
   `Key('stripeModeToggle')`, segments labelled **`Test`** and **`Live`**.
   Selecting a segment calls `repository.setSelectedMode(...)`. Live and Test are
   fully independent views.
2. Compute `connected = connectedAccountForMode(accounts, selectedMode)` and
   `archived = archivedAccountsForMode(accounts, selectedMode)`.
3. **When `connected == null`:**
   - Show a **`Create a Stripe account`** button (this replaces the old
     "Connect Stripe"; it still calls `createStripeAccount` + account link flow).
   - **If `archived` is non-empty:** also show a **`Reconnect Stripe account`**
     button with help text exactly
     **`reconnect a previously used Stripe account`**. (Picking which archived
     account to reconnect can be a menu/dialog calling
     `reconnectStripeAccount`.)
4. **When `connected != null`:** keep the status panel (uses
   `stripeConnectionStatusProvider`): **`Disconnect Stripe`** button (→
   `disconnectStripeAccount(stripeMode: selectedMode)`), a `Continue setup`
   button when not ready, and a payments on/off `Switch` with
   `Key('paymentsActiveToggle')` bound to `connected.isActive` (→
   `changeStripeIntegrationActivation`). Do not show "Create a Stripe account".
5. **Previously-used (archived) accounts** for the selected mode: render a list;
   each row has a delete control with `Key('deleteArchivedAccount_<accountId>')`.
   Tapping opens an `AlertDialog` whose body contains the substring
   **`cannot be retrieved`** (prominent irreversible warning). Confirming calls
   `deleteStripeAccount(accountId: ...)`.

Keep `if (status.isReady) const ShoppingCartSettings()` behavior for the
connected+ready case.

---

## 5. Exact copy strings (must match the tests)

- `Create a Stripe account`
- `Reconnect Stripe account`
- `reconnect a previously used Stripe account`
- Delete-confirmation body contains: `cannot be retrieved`
- Mode toggle segment labels: `Test`, `Live`
- Disconnect button: `Disconnect Stripe`

## 6. Widget keys (must match the tests)

- `Key('stripeModeToggle')`
- `Key('paymentsActiveToggle')`
- `Key('deleteArchivedAccount_<accountId>')`

---

## 7. Migration & cleanup

- **Data migration:** existing docs store `test`/`live`/`activeMode` map fields.
  Write a one-off migration (script or lazy upgrade on read) that, per account:
  for each of `test`/`live` with an `accountId`, create
  `.../accounts/{accountId}` with `archived:false, isActive:<old isActive>,
  mode:<that mode>, connectedAt:<old connectedAt or now>`; set
  `selectedMode = old activeMode`; then remove the legacy fields. Handle the
  legacy *flat* `{accountId, isActive}` doc as a `test` account.
- **Obsolete tests:** the old map-field tests in `functions/test_main.py`
  (`test_disconnect_stripe_account_removes_active_test_mode_only`,
  `..._removes_active_live_mode_only`, `..._cleans_legacy_flat_test_connection`,
  the `finalize`/`status` tests that assert the `test`/`live` map shape) describe
  the **old** behavior and will break. Update or delete them to match §2–§3 once
  the new behavior is implemented. Do this deliberately — they are the only
  tests that should be removed.
- Delete dead code: `StripeConnection`/`StripeModeConnection`,
  `stripeConnectionProvider`, `_set_mode_connection_active`,
  `_save_stripe_mode_connection`, `_disconnect_active_stripe_connection`,
  `get_mode_connection`/`get_active_mode_connection` once unreferenced.

---

## 8. Definition of done

1. `python -m unittest test_stripe_accounts_overhaul` — all green.
2. `flutter test test/settings/stripe_accounts_overhaul_test.dart` — all green.
3. `flutter test test/settings/stripe_accounts_widgets_test.dart` — all green.
4. `functions/test_main.py` — green after updating the obsolete legacy tests
   per §7.
5. `flutter analyze` clean; `build_runner` regenerated.
6. Manual smoke test: connect → disconnect (row becomes archived, not deleted) →
   reconnect → toggle Live/Test → toggle payments on/off → delete an archived
   account (warned) in both Test and Live.
```
