# Create Team / Team Builder Executive Report

Scope: `/createteam`, primarily `lib/create_team`, plus the supporting providers and models used for dog availability, customer assignment, saving, loading, history, and copy/export.

Important product premise: this app is a niche CRM for commercial sled dog kennels, built under severe resource constraints. The team builder should maximize operational flexibility. Warnings must inform the manager, not block the manager. Optional fields, empty rows, zero capacity, over-capacity sleds, unnamed groups, and selected "not supposed to run" dogs can all be legitimate in real kennel work.

This report has therefore been updated to distinguish between actual bugs and intentional flexibility.

## Executive Summary

The create team feature has the right foundation for launch: it lets a kennel manager build teams quickly, leaves room for real-world exceptions, integrates dog notes/warnings, supports customer assignment, saves team history, and provides a lightweight copy format for external channels such as WhatsApp.

The launch risk is not that the app allows too much flexibility. That flexibility is a correct product choice for this market. The real launch risks are:

- Some warning/validation signals are incorrect or misleading.
- Some UI actions claim to do something but do not.
- Some save paths can produce inconsistent state.
- Some controls are not actually read-only when the page says they are.
- Some customer assignment interactions are easy to misread or trigger accidentally.
- Some layout and copy choices make a high-pressure workflow harder than it needs to be.

The practical launch goal should be: keep the builder permissive, but make it honest, visible, and hard to accidentally corrupt. The right validation model is advisory, not blocking.

## 1. Current Bugs

### Launch-Blocking / Critical

#### Critical: Duplicate detection is tied to the wrong provider for loaded teams

Evidence:
- `duplicateDogsProvider` reads `createTeamGroupProvider(null)` in `lib/create_team/riverpod.dart:389-415`.
- Loaded team groups use `loadedTeamId`, passed into `CreateTeamMain` and then into `TeamBuilderWidget` as `providerKey` in `lib/create_team/main.dart:97-101`.
- Active builder mutations use `createTeamGroupProvider(widget.providerKey)` in `lib/create_team/team_builder/main.dart:56-58`.

Impact:
When editing a loaded team group, duplicate warnings may be calculated against the new-team provider instead of the loaded workspace. This can hide real duplicate dogs or show duplicate warnings from an unrelated unsaved provider. Because duplicate warnings are a core informational signal, this should be fixed before launch.

Recommended fix:
Make duplicate detection use the active workspace. The simplest 80/20 fix is to calculate duplicates from `widget.teamGroup` directly, similar to `runningDogsProvider(widget.teamGroup)`, or parameterize the provider by `teamGroupId`/workspace.

#### Critical: Dog filter reports success but does not affect selector options

Evidence:
- `DogFilterWidget` returns filtered dogs through `onResult`.
- In `TeamBuilderWidget`, `onResult` only shows `"Filter successful"` and does not store the result or pass it to selectors in `lib/create_team/team_builder/main.dart:85-104`.
- `TeamRetriever` still receives `dogs: allDogs` in `lib/create_team/team_builder/main.dart:183-188`.

Impact:
This is a trust-breaking bug. The user is told the filter succeeded, but the available selector list does not change. Even if advanced filtering is not launch priority, a visible control must either work or be removed/hidden.

Recommended fix:
For launch, choose one:
- Implement the existing filter result with local state and pass filtered dogs into `TeamRetriever`.
- Or remove/hide the filter UI until filtering is ready.

Given the focus group has not prioritized filtering for launch, the lower-effort launch fix may be to remove or hide this filter section temporarily.

#### Critical: Save operation is not fully awaited and can report success too early

Evidence:
- `SaveTeamsButton` saves team data, then customer data, as separate async operations in `lib/create_team/save_teams_button.dart:31-34`.
- `saveToDb` calls `_removeCustomerGroups(newtg.id, account, newtg.date);` without `await` in `lib/create_team/save_teams_button.dart:157`.
- `_removeCustomerGroups` performs Firestore writes in a separate batch in `lib/create_team/save_teams_button.dart:230-256`.

Impact:
The UI can show "Teams saved" even though cleanup of old customer-group links is still running or has failed. Errors from `_removeCustomerGroups` are not caught by the save button's try/catch. This can leave team history and customer-group links out of sync.

Recommended fix:
Await `_removeCustomerGroups`. Add a simple saving state that disables the save/new buttons while save is in progress. Do not over-engineer with transactions yet unless inconsistency appears in testing.

#### Critical: Customer assignment interaction can move customers between sleds too easily

Evidence:
- `CustomerActionChip` always calls `onCustomerSelected()` when tapped, including customers already assigned to another team in `lib/create_team/customers/main.dart:312-324`.
- Assignment overwrites `teamId` directly in `lib/create_team/customers/main.dart:41-46`.
- The only explanation of colors is hidden in a tooltip in `lib/create_team/customers/main.dart:175-185`.

Impact:
Over-capacity itself is not a bug in this product, and moving customers can be legitimate. The bug is interaction ambiguity: a user can accidentally move a customer from another sled with a simple tap, without clear wording that a move is happening.

Recommended fix:
Keep the workflow permissive, but make the state explicit:
- Label customer chips as "Available", "On this sled", or "On another sled".
- If a customer is assigned elsewhere, tapping should say "Move here" or require a small confirmation.
- Keep over-capacity allowed, but show the count clearly.

### High Severity

#### High: Removing a dog stores an empty string instead of clearing the field

Evidence:
- Dog removal calls `notifier.changePosition(dogId: "", ...)` in `lib/create_team/team_builder/main.dart:208-215`.
- `DogPairWorkspace.firstDogId` and `secondDogId` are nullable strings in `lib/create_team/riverpod.dart:47-49`.
- `RunningDogs` treats any non-null value as a selected dog in `lib/create_team/riverpod.dart:374-381`.

Impact:
Empty strings can be persisted as fake dog IDs. They may not display, but they can pollute saved data, export logic, duplicate calculations, analytics, and future maintenance.

Recommended fix:
Represent empty positions as `null`, not `""`. Add a `clearPosition` method or allow `changePosition` to accept `String?`.

#### High: Add row ignores read-only mode

Evidence:
- The "Add new row" button always calls `widget.onAddRow(widget.teamNumber)` and is not disabled when read-only in `lib/create_team/team_builder/team_retriever.dart:157-162`.

Impact:
The page can still be modified when the UI says it is in read-only/safety mode. This defeats the purpose of the safety switch.

Recommended fix:
Disable "Add new row" when `isReadOnly` is true.

#### High: Invalid index guard is after unsafe access

Evidence:
- `TeamRetriever.build` reads `TeamWorkspace team = widget.teams[widget.teamNumber];` before checking whether the index is valid in `lib/create_team/team_builder/team_retriever.dart:65-69`.

Impact:
If the team list changes during rebuilds, this can throw before the fallback text renders.

Recommended fix:
Move the bounds check before any indexed access.

#### High: Group and team text controllers can become stale after provider reloads

Evidence:
- `groupNameController` and `groupNotesController` are initialized only once in `TeamBuilderWidget.initState` in `lib/create_team/team_builder/main.dart:36-40`.
- `teamNameController` is initialized only once in `TeamRetriever.initState` in `lib/create_team/team_builder/team_retriever.dart:49-55`.

Impact:
If the loaded team group changes under the same widget instance, the text fields can display stale values while the provider state has changed. This is especially relevant when loading history, invalidating providers, or starting a new team group.

Recommended fix:
Add a lightweight `didUpdateWidget` sync keyed by `teamGroup.id` and team id.

#### High: Saving team/customer state has no in-progress lock

Evidence:
- The save button async handler does not set an `isSaving` flag or disable repeated presses in `lib/create_team/save_teams_button.dart:27-69`.

Impact:
Users can double-tap save and launch overlapping writes. In a high-pressure kennel environment this is plausible.

Recommended fix:
Add a local/provider `isSaving` state. Disable save and new-team actions while saving and show a small progress indicator.

### Medium Severity

#### Medium: Copy/export can crash on edge-case empty output

Evidence:
- `CreateTeamsString.teamGroup` calls `substring(0, stringTeams.length - 2)` in `lib/create_team/team_builder/main.dart:262-270`.

Impact:
The default workspace likely avoids this today, but the string builder is brittle. If a corrupted or future state contains no teams, this can throw.

Recommended fix:
Make string generation safe for empty team lists. Keep the export lightweight. Do not add date, run type, customer data, warnings, or full dispatch details unless the user explicitly asks for a richer share format later.

#### Medium: Date and distance controls recreate controllers during build

Evidence:
- `DateTimeDistancePicker` creates new `TextEditingController` instances inside `build` for date and time in `lib/create_team/team_builder/select_datetime.dart:20-96`.

Impact:
This is not launch-blocking, but it is inefficient and can cause focus/cursor oddities. The distance field also uses a provider controller and may not display loaded `teamGroup.distance` consistently.

Recommended fix:
Use stable controllers or simple text display for read-only date/time fields. Ensure loaded distance is visible when present.

#### Medium: "Create new team group" exists twice with different reset behavior

Evidence:
- `TeamBuilderWidget` has a "Create new team group" button using `Navigator.of(context).popAndPushNamed("/createteam")` in `lib/create_team/team_builder/main.dart:241-249`.
- `SaveTeamsButton` has another "Create a new team group" button using `context.pushReplacement("/createteam")` and invalidating `distanceControllerProvider` in `lib/create_team/save_teams_button.dart:78-87`.

Impact:
Two similar actions increase confusion and can reset state differently.

Recommended fix:
Keep one visible "Start new plan" action, preferably in the persistent footer. If both remain, make them call the same reset helper.

#### Medium: Read-only mode is global/manual and not consistently described

Evidence:
- `isReadOnlyProvider` defaults to `false` in `lib/create_team/riverpod.dart:460-469`.
- The label says `"Read only: when selected. you can't edit anything (for safety)."` in `lib/create_team/team_builder/main.dart:65-69`.
- At least one edit action still works in read-only mode.

Impact:
Read-only can still be useful as a safety feature, but it currently feels like a rough developer control. It is unclear when a user should use it, and it is not fully enforced.

Recommended fix:
Rename to "Review mode" and enforce it consistently. Do not add complex edit-lock workflows for launch unless needed.

#### Medium: Customer tab empty state is a dead end

Evidence:
- If no customer group is assigned, the tab only shows `"No customer group assigned"` in `lib/create_team/customers/main.dart:20-27`.
- `CustomerAssign.createCustomerGroup` exists in `lib/create_team/riverpod.dart:108-123` but is not exposed in this UI.

Impact:
The tab does not explain how to attach customers. This matters even if run type has no practical behavior today.

Recommended fix:
For launch, keep it simple: add a short empty-state sentence explaining where customer groups are assigned/linked. Do not build run-type-dependent behavior yet.

#### Medium: Analyzer currently fails

Evidence:
- `dart analyze` exits with code 2 and reports 43 issues. The visible issues are mostly outside create-team code.

Impact:
Analyzer noise makes it harder to detect future regressions.

Recommended fix:
At minimum, keep create-team files clean and avoid adding new analyzer issues. Full repo cleanup can be staged.

### Not Bugs / Intentional Flexibility

#### Advisory fatal dog warnings are intentional

The app should notify users when a dog is not supposed to run under current conditions, but it should not block selection or saving. Real sled dog operations require judgment calls: a heat warning may not matter on a small female-only guide sled, and a minor injury may be assessed on a short controlled run.

Recommended refinement:
Keep warning selection permissive. Improve visibility only:
- Make fatal/warning/info states readable.
- Show selected warning dogs clearly in the team.
- Consider an advisory save warning later, but do not block save.

#### Optional names, distance, capacity, run type, and empty rows are intentional

The app correctly allows incomplete-looking team groups because empty fields can be meaningful or simply irrelevant. A zero-capacity private training sled, unnamed team, empty row, or over-capacity sled can be valid in chaotic live operations.

Recommended refinement:
Do not require these fields. If a pre-save advisory is added, keep it informational and dismissible.

#### Over-capacity sleds are not inherently errors

Capacity is a planning hint, not a hard rule. A kennel manager may intentionally add a small child, guide, or special-case customer without changing the sled's base capacity.

Recommended refinement:
Continue allowing over-capacity. Make the over-capacity state visually clear, not blocked.

#### Run type currently has no practical implications

Run type can remain a saved/displayed field for future stats. Do not build tour/non-tour logic around it for launch.

## 2. Missing Features and Recommended Additions

### Must Add or Fix Before Launch

#### Lightweight advisory save summary

Add a small pre-save advisory dialog or inline summary. It should not block save by default. The goal is to prevent blind saves, not to enforce a rigid workflow.

Recommended 80/20 contents:
- Duplicate dogs.
- Selected dogs with fatal warnings.
- Customer assignment count, if a customer group exists.
- Teams over listed capacity, if capacity is non-zero.
- Empty team group warning only if there are literally no dogs selected.

Do not include optional field warnings for missing name, distance, run type, zero capacity, empty rows, or partial rows. Those are legitimate product choices.

Suggested behavior:
- If there are no advisory issues: save directly.
- If there are advisory issues: show "Review before saving" with "Cancel" and "Save anyway".
- Do not require override reasons or audit trails.

#### Functional or hidden dog filter

The current filter UI must not remain in a fake-success state. For launch, hiding it is acceptable if filtering is not a priority. If implemented, keep it to the existing generic filter and avoid adding opinionated presets for now.

#### Save-state protection

Add a simple saving lock:
- Disable save button while saving.
- Disable "Start new plan" while saving.
- Show small spinner or "Saving...".
- Only show success after all awaited operations finish.

This is small work with high reliability value.

#### Customer assignment clarity

Keep assignment flexible, but make movement explicit:
- Show labels for available / assigned here / assigned elsewhere.
- Rename action for assigned-elsewhere customers to "Move here".
- Keep over-capacity allowed.
- Keep customer assignment in its own tab; that separation matches actual kennel workflow.

#### Read-only/review mode consistency

Fix all controls that mutate state while read-only is active. Rename the control to "Review mode" if possible. This is a low-cost safety improvement.

### Valuable Soon After Launch

#### Saved templates / duplicate workflow

History already supports duplication. A lightweight "use as template" workflow could be valuable after launch:
- Duplicate a past team into today.
- Keep team structure.
- Let warnings show naturally on current conditions.

This should build on existing history duplication instead of introducing a heavy template system.

#### Better warning display

Because warnings are advisory, the UX needs to make them noticeable without blocking work:
- Compact badges on selected dog chips.
- Clear color/icon legend visible without a tooltip.
- Team-level warning count.
- Dog profile link for details if cheap to implement.

#### Pair intelligence

This may become one of the most valuable kennel-specific features later:
- Favorite/avoid pair notes.
- Pair history.
- Last run together.
- Compatibility warnings.

This is not launch-critical.

#### Workload context

Distance warnings already exist. Later, the builder could show more compact workload context:
- Last run.
- Recent distance.
- Rest days.
- Soft/hard workload warning.

This should stay advisory.

#### Customer empty-state linking

The customer tab should eventually support linking or creating customer groups directly, but only if this matches the wider customer-management workflow. For launch, explanatory empty-state copy is enough.

### Explicitly Out of Scope for Launch

These ideas may be useful later, but should not be prioritized before launch:

- Override workflow with reason/audit trail.
- Blocking validation rules.
- Required names, distances, run types, capacities, or complete rows.
- Opinionated quick filter presets.
- Position-aware selection.
- Assign-all-to-team.
- Auto-distribution by capacity.
- Drag-and-drop or swap mode.
- Undo stack for destructive actions.
- Separate desktop and mobile customer/team layouts.
- Keeping customer data visible while building dog teams.
- Full dispatch PDF/print export.
- Staff/guide assignment.
- Weather/trail/load modeling.
- Version history and audit log.

The common reason: these add complexity before the product has proven which workflow refinements matter most. The launch focus should be correctness, clarity, and low-friction manual control.

## 3. UI and UX Improvements

### Overall UX Diagnosis

The current interface is useful but still feels like raw Flutter controls assembled into a form. For this market, the interface does not need to become a polished dispatch command center before launch. It does need to become clearer, denser, and less misleading.

The best direction is a practical kennel operations screen:
- Fast to use.
- Permissive.
- Obvious about warnings.
- Minimal extra clicks.
- No hidden "smart" assumptions.
- One layout that works acceptably on both desktop and mobile.

### What Is Working

- The two-tab model is conceptually sound. Team building and customer assignment are separate kennel operations, often done at different times and sometimes by different staff.
- Advisory warnings fit the domain better than hard blockers.
- The copy feature is correctly lightweight for sharing through WhatsApp or similar channels.
- The team/dog-pair model is simple and understandable.
- Capacity as a visible count is useful, as long as it remains a hint rather than a hard constraint.

### Highest-Impact UX Fixes

#### Make warnings more visible, not more restrictive

Current issue:
Unavailable/fatal dogs are greyed in the selector and notes appear under chips, but warning visibility is inconsistent and can become noisy.

Recommendation:
- Use compact warning badges on selected dog chips.
- Keep warning text expandable or smaller.
- Add a small team-level warning count.
- Keep all warnings advisory.

#### Simplify the top area

Current issue:
Read-only checkbox, filter card, date/time/distance, name, notes, run type, and capacity are stacked without a strong hierarchy.

Recommendation:
Group the top controls into a compact "Run setup" area:
- Date.
- Time.
- Distance.
- Run name.
- Notes.
- Run type.
- Review mode.

Do not overbuild a dashboard. Just make the first screen scan better.

#### Clarify customer assignment states

Current issue:
The customer assignment UI relies on blue/grey/green and a tooltip to explain state.

Recommendation:
Use visible labels:
- Available.
- On this sled.
- On another sled.

For assigned-elsewhere customers, use "Move here" instead of making the whole card behave like an ordinary select action.

#### Keep the two-tab workflow

Do not merge customers into the team builder for launch. The user's domain clarification is decisive: dog team building happens before customers arrive, and customer assignment is a separate operation. The current tabs support that mental model.

Recommended small improvement:
Show a compact customer status in the Customers tab label or top of the Customers tab only. Avoid adding customer data into team cards for now.

#### Improve destructive action clarity without adding undo

Undo is not worth the current implementation cost, because the user can exit without saving. Still, destructive controls should be less accidental:
- Make remove-row and remove-team icons/buttons visually distinct.
- Consider a lightweight confirmation only for removing a non-empty team.
- Keep this simple; do not build an undo stack.

### Responsive Direction

Build one layout that degrades gracefully across desktop and mobile. Avoid separate desktop/mobile workflows.

Current concern:
`PairRetriever` uses a horizontal row with two dog selectors, a separator, and a delete icon in `lib/create_team/team_builder/pair_retriever.dart:37-99`. This may get cramped with long dog names or warnings.

Recommendation:
- Use wrapping or responsive stacking for the two selectors when width is tight.
- Keep tap targets large enough.
- Prevent warning text from forcing awkward row height explosions.
- Test with long dog names, many warnings, and several teams.

### Copy and Microcopy

Recommended copy changes:
- "Create team" -> "Build teams" or keep "Create team" if already familiar.
- "Group name" -> "Run name" if that matches kennel language.
- "Group notes" -> "Run notes".
- "Copy team group" -> "Copy team list".
- "Create new team group" -> "Start new plan".
- "Read only: when selected. you can't edit anything (for safety)." -> "Review mode" with helper text "Prevents accidental edits."
- "No customer group assigned" -> "No customers linked yet. Link customers from the customer management area."

### Visual Design Direction

Use the `lib/health` section as the visual reference, per repository instructions. The target is not decorative or marketing-like. It should feel like a calm, practical tool for a working kennel.

Recommended visual principles:
- Dense but readable.
- Stronger hierarchy between run setup, team cards, dog rows, and footer actions.
- Status colors paired with text/icons, not color alone.
- Fewer nested cards.
- Clear destructive actions.
- No large decorative UI.

Anti-pattern verdict:
The screen does not look like generic AI-generated UI. It looks utilitarian but unfinished. The main visual issue is weak hierarchy and rough default controls, not excessive decoration.

### Suggested Launch Milestone

Before public launch, the minimum create-team scope should be:

1. Fix duplicate detection for the active team group.
2. Remove or implement the dog filter so it no longer fakes success.
3. Await all save operations and add a saving lock.
4. Clear dog slots with `null`, not empty string.
5. Make read-only/review mode actually prevent all edits.
6. Fix the invalid index access in `TeamRetriever`.
7. Add safe lightweight copy/export string generation.
8. Improve customer assignment labels so moving a customer is explicit.
9. Add a very light advisory save summary, with "Save anyway", not blocking validation.
10. Do a responsive pass on dog rows and warning display.

This list is intentionally smaller than the first version of the report. It focuses on launch-readiness without turning the team builder into a heavy dispatch platform too early.

## Verification Notes

- Read application code under `lib/create_team`, `lib/services/riverpod/dog_notes.dart`, team/teamgroup models, history loading, and save paths.
- Ran `dart analyze`. It reported 43 issues and exited with code 2; none of the displayed analyzer issues were direct create-team compile errors, but the repository is not analyzer-clean.
- No application code was changed. This report is the only file updated.
