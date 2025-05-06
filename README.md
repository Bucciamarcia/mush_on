# mush_on

A cool and open source CRM for sled dog kennels.

## Changelog

### 0.0.3

- Included AGPL license in open source repo.
- Fixed bug that duplicates teams when they're saved in the same minute.
- Stats page updates immediately after a team is saved.
- Fix: Resolved issue where date range generation could incorrectly exclude the final day (current date) due to DST transitions affecting DateTime time components used in loop termination logic. Dates are now normalized to midnight during generation.
- Asks for confirmation when leaving the create team page with unsaved changes.

### 0.0.4

- Fixed bug in the conversion between local time and UTC time.
- Fixed a bug that sometimes allows the creation of multiple teams at the same time.
- Now the system will never delete more than 1 team group at a time, and return an error if there is more than one match.

### 0.0.5

- BREAKING: Switched to using IDs instead of names to handle dogs. Non-updated apps will break.

### 0.0.6

- Fixed a bug where team names would not be displayed in team creator once loaded.
- Fixed bug where total distances in stats page would not be displayed.
- Replaced login screen and changed its design to allow for multiple sign-in methods (to be yet implemented).
- Create team now displays a visual feedback when a dog is selected.
- Created dog page.
- Added birthday, sex and age to dog.
- Can now uplaod dog picture.
- Can now edit dog name.
- Can now tag dog.

### 0.0.7

- Added filtering for dogs in kennel.
- Added delete dog button in dog page.
- Fixed a bug where new or deleted dogs wouldn't appear in edit kennel.
- Fixed a bug where lowercase dogs would always appear last.
- "Edit kennel" renamed to "Kennel" for clarity.

## Improvements

Break Down Large Widgets/Classes: This is likely the highest impact change for maintainability.
Target: DogMain, TeamRetriever, PairRetriever, _CreateTeamMainState build method, GridRowProcessor.
Action: Extract logical UI sections into smaller, dedicated StatelessWidgets or StatefulWidgets. For GridRowProcessor, break the run method into smaller private helper methods (e.g., _aggregateDailyStats, _calculateMonthlySummaries, _buildGridRows).
Why: Improves readability, makes widgets easier to reason about, reuse, and potentially test later. Reduces nesting depth.
Introduce Basic Testing: Even minimal testing provides huge value.
Target: Start simple. Unit test pure logic functions (e.g., Dog.age calculation, helper methods extracted from GridRowProcessor, maybe some provider logic that doesn't depend heavily on external services). Consider simple widget tests for reusable UI components like DogSelectedChip or PositionCard.
Action: Create a test directory. Add the flutter_test dependency. Write a few simple unit tests using test() and expect(). Write a basic widget test using testWidgets() and tester.pumpWidget().
Why: Catches regressions before you manually test everything. Builds confidence when refactoring. Documents expected behavior. Even 10-20% test coverage on critical/complex parts is vastly better than 0%.
Constants for Keys and Strings:
Target: String literals used in Key("..."), potentially Firestore field names or collection paths (though you have abstracted some paths).
Action: Define const String dogSelectorKeyPrefix = 'dog_selector_'; etc., and use string interpolation: Key('$dogSelectorKeyPrefix${widget.teamNumber}_...'). Or use ValueKey which is often simpler: ValueKey('dog_selector_${widget.teamNumber}_...'). For Firestore paths/fields, define constants in a separate file.
Why: Reduces typos, makes searching/refactoring easier, improves maintainability.
Refine Loading/Error UI Feedback:
Target: Async operations triggered by user actions (button presses like saving, deleting, uploading images).
Action: Ensure every such action provides immediate feedback. The global LoadingOverlay is okay, but consider disabling the button and showing a small inline CircularProgressIndicator for a slightly better UX. Ensure error Snackbars provide enough context for you (the developer) to debug if needed, while still being user-friendly.
Why: Improves perceived performance and user confidence. Makes debugging easier.
Simplify TeamsHistoryProvider Loading:
Target: The _isLoading = [false, false] list.
Action: Use a single bool isLoading = false; and maybe String? errorMessage;. Set isLoading = true at the start of _fetchGroupObjects and _fetchAllDogsById. Set it to false in the listen callback (in onData and onError) and in the finally block of _fetchAllDogsById. Set errorMessage in onError.
Why: Simpler state to manage and reason about.
(Optional/Future) Consider a Router: If you plan to add significantly more screens or need complex navigation/deep linking.
Target: Current Navigator.pushNamed calls.
Action: Evaluate go_router.
Why: Provides type-safe routing, handles parameters better, simplifies navigation logic, essential for web support if needed later. (Lower priority for now if the app isn't growing much more).
