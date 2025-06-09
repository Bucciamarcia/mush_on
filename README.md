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

### 0.0.8

- In create team, dogs already selected are at the bottom and unavailable to avoid duplicates.
- Added flags "Prevents for running" and "Show in team builder" for tags.
- Tags preventing from running cause error in team builder.
- Show in team builder tags now are shown in team builder.

### 0.0.9

- Fixes a bug where the filter would include expired tags.
- Can now pick date range in the stats page.
