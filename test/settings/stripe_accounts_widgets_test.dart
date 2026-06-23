// Failing widget tests guiding the Stripe settings UI overhaul: a Live/Test
// toggle at the top, "Create a Stripe account" / "Reconnect Stripe account"
// states, a payments on/off toggle, and per-account deletion of archived
// connections with a prominent irreversible-delete warning.
//
// Expected NOT to compile / pass against the current code base. They pass once
// `stripe_config_worksheet.md` is implemented.
//
// Run: flutter test test/settings/stripe_accounts_widgets_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/settings/stripe/riverpod.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'package:mush_on/settings/stripe/stripe_payment_settings.dart';

// ---- Widget contract (keys / copy the implementation must use) -------------
//
//   Key('stripeModeToggle')      -> SegmentedButton<StripeMode> at the top.
//   Key('paymentsActiveToggle')  -> Switch reflecting the global Stripe
//                                   `isActive` user intent to accept payments.
//   Key('deleteArchivedAccount_<accountId>') -> delete control per archived row.
//
//   Copy (exact strings):
//     - "Create a Stripe account"
//     - "Reconnect Stripe account"
//     - "reconnect a previously used Stripe account"
//     - Delete warning contains: "cannot be retrieved"
// ----------------------------------------------------------------------------

Future<void> _pump(
  WidgetTester tester, {
  required StripeMode selectedMode,
  required List<StripeAccount> accounts,
  bool integrationActive = false,
  StripeConnectionStatus? status,
}) async {
  final overrides = <Override>[
    accountProvider.overrideWith((_) => Stream.value('account-1')),
    selectedStripeModeProvider.overrideWith((_) => Stream.value(selectedMode)),
    stripeIntegrationActiveProvider.overrideWith(
      (_) => Stream.value(integrationActive),
    ),
    stripeAccountsProvider.overrideWith((_) => Stream.value(accounts)),
  ];
  if (status != null) {
    overrides.add(
      stripeConnectionStatusProvider(
        'account-1',
      ).overrideWith((_) async => status),
    );
  }
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: const MaterialApp(home: Scaffold(body: PaymentSettingsWidget())),
    ),
  );
  await tester.pumpAndSettle();
}

StripeConnectionStatus _readyStatus(StripeMode mode) => StripeConnectionStatus(
  activeMode: mode,
  hasAccount: true,
  isReady: true,
  chargesEnabled: true,
  payoutsEnabled: true,
  detailsSubmitted: true,
  disabledReason: null,
  reason: 'Stripe is ready to accept payments.',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows a Live/Test mode toggle at the top', (tester) async {
    await _pump(tester, selectedMode: StripeMode.test, accounts: const []);

    expect(find.byKey(const Key('stripeModeToggle')), findsOneWidget);
    expect(find.text('Test'), findsWidgets);
    expect(find.text('Live'), findsWidgets);
    expect(find.text('Refresh connection'), findsOneWidget);
  });

  testWidgets(
    'no accounts: shows "Create a Stripe account" and no reconnect option',
    (tester) async {
      await _pump(tester, selectedMode: StripeMode.test, accounts: const []);

      expect(find.text('Create a Stripe account'), findsOneWidget);
      expect(find.text('Reconnect Stripe account'), findsNothing);
    },
  );

  testWidgets(
    'archived-only: offers reconnect with the previously-used help text',
    (tester) async {
      await _pump(
        tester,
        selectedMode: StripeMode.test,
        accounts: const [
          StripeAccount(
            accountId: 'acct_old',
            mode: StripeMode.test,
            archived: true,
          ),
        ],
      );

      expect(find.text('Create a Stripe account'), findsOneWidget);
      expect(find.text('Reconnect Stripe account'), findsOneWidget);
      expect(
        find.text('reconnect a previously used Stripe account'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'archived accounts of the OTHER mode are not offered for reconnect',
    (tester) async {
      await _pump(
        tester,
        selectedMode: StripeMode.test,
        accounts: const [
          StripeAccount(
            accountId: 'acct_live_old',
            mode: StripeMode.live,
            archived: true,
          ),
        ],
      );

      // Selected mode is test, the only archived account is live -> no reconnect.
      expect(find.text('Reconnect Stripe account'), findsNothing);
      expect(find.text('Create a Stripe account'), findsOneWidget);
    },
  );

  testWidgets(
    'connected & ready: shows disconnect and the payments on/off toggle',
    (tester) async {
      await _pump(
        tester,
        selectedMode: StripeMode.test,
        status: _readyStatus(StripeMode.test),
        accounts: const [
          StripeAccount(
            accountId: 'acct_connected',
            mode: StripeMode.test,
            archived: false,
          ),
        ],
        integrationActive: true,
      );

      expect(find.text('Disconnect Stripe'), findsOneWidget);
      expect(find.byKey(const Key('paymentsActiveToggle')), findsOneWidget);
      expect(find.text('Accept payments globally'), findsOneWidget);
      expect(find.text('Connected account: acct_connected'), findsOneWidget);
      expect(find.text('Create a Stripe account'), findsNothing);
    },
  );

  testWidgets('deleting an archived connection warns it cannot be retrieved', (
    tester,
  ) async {
    await _pump(
      tester,
      selectedMode: StripeMode.test,
      accounts: const [
        StripeAccount(
          accountId: 'acct_old',
          mode: StripeMode.test,
          archived: true,
        ),
      ],
    );

    await tester.tap(find.byKey(const Key('deleteArchivedAccount_acct_old')));
    await tester.pumpAndSettle();

    expect(find.textContaining('cannot be retrieved'), findsOneWidget);
  });
}
