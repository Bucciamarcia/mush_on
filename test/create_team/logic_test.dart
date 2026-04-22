import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/services/models.dart';

void main() {
  group('DogNotesExtension', () {
    test('addOrModify appends a new dog note when dog is not present', () {
      final notes = <DogNote>[
        DogNote(
          dogId: 'dog-1',
          dogNoteMessage: [DogNoteMessage(type: DogNoteType.duplicate)],
        ),
      ];

      final updated = notes.addOrModify(
        DogNote(
          dogId: 'dog-2',
          dogNoteMessage: [
            DogNoteMessage(type: DogNoteType.tagPreventing, details: 'Rest'),
          ],
        ),
      );

      expect(updated, hasLength(2));
      expect(updated.last.dogId, 'dog-2');
      expect(updated.last.dogNoteMessage.single.message, 'Has tag: Rest');
    });

    test('addOrModify merges messages when dog already exists', () {
      final updated =
          <DogNote>[
            DogNote(
              dogId: 'dog-1',
              dogNoteMessage: [DogNoteMessage(type: DogNoteType.duplicate)],
            ),
          ].addOrModify(
            DogNote(
              dogId: 'dog-1',
              dogNoteMessage: [
                DogNoteMessage(
                  type: DogNoteType.healthEventError,
                  details: 'injury',
                ),
              ],
            ),
          );

      expect(updated, hasLength(1));
      expect(updated.single.dogNoteMessage.map((note) => note.message), [
        'Duplicate dog!',
        'Health event: injury',
      ]);
    });

    test('type filters return notes by highest severity present', () {
      final notes = [
        DogNote(
          dogId: 'info-dog',
          dogNoteMessage: [
            DogNoteMessage(type: DogNoteType.showTagInBuilder, details: 'VIP'),
          ],
        ),
        DogNote(
          dogId: 'warning-dog',
          dogNoteMessage: [DogNoteMessage(type: DogNoteType.heatLight)],
        ),
        DogNote(
          dogId: 'fatal-dog',
          dogNoteMessage: [DogNoteMessage(type: DogNoteType.duplicate)],
        ),
      ];

      expect(notes.typeNote().map((note) => note.dogId), ['info-dog']);
      expect(notes.typeWarning().map((note) => note.dogId), ['warning-dog']);
      expect(notes.typeFatal().map((note) => note.dogId), ['fatal-dog']);
    });
  });

  group('DogNoteRepository', () {
    test('addNote creates a new DogNote when id is missing', () {
      final notes = DogNoteRepository.addNote(
        notes: [],
        dogId: 'dog-1',
        newNote: DogNoteMessage(type: DogNoteType.duplicate),
      );

      expect(notes, hasLength(1));
      expect(notes.single.dogId, 'dog-1');
      expect(notes.single.dogNoteMessage.single.type, DogNoteType.duplicate);
    });

    test('addNote returns a copied note when appending to an existing dog', () {
      final original = [
        DogNote(
          dogId: 'dog-1',
          dogNoteMessage: [DogNoteMessage(type: DogNoteType.duplicate)],
        ),
      ];

      final updated = DogNoteRepository.addNote(
        notes: original,
        dogId: 'dog-1',
        newNote: DogNoteMessage(type: DogNoteType.heatLight),
      );

      expect(updated, isNot(same(original)));
      expect(updated.single.dogNoteMessage.map((note) => note.type), [
        DogNoteType.duplicate,
        DogNoteType.heatLight,
      ]);
      expect(original.single.dogNoteMessage, hasLength(1));
    });

    test('removeNoteType strips only the requested type', () {
      final note = DogNote(
        dogId: 'dog-1',
        dogNoteMessage: [
          DogNoteMessage(type: DogNoteType.duplicate),
          DogNoteMessage(type: DogNoteType.heatLight),
        ],
      );

      final updated = DogNoteRepository.removeNoteType(
        note,
        DogNoteType.duplicate,
      );

      expect(updated.dogNoteMessage, hasLength(1));
      expect(updated.dogNoteMessage.single.type, DogNoteType.heatLight);
    });

    test('findById returns matching note or null', () {
      final notes = [
        DogNote(
          dogId: 'dog-1',
          dogNoteMessage: [DogNoteMessage(type: DogNoteType.duplicate)],
        ),
      ];

      expect(DogNoteRepository.findById(notes, 'dog-1')?.dogId, 'dog-1');
      expect(DogNoteRepository.findById(notes, 'missing'), isNull);
    });
  });

  group('CreateTeamGroup provider', () {
    test('builds a default workspace for a new team group', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final workspace = await container.read(
        createTeamGroupProvider(null).future,
      );

      expect(workspace.id, isNotEmpty);
      expect(workspace.teams, hasLength(1));
      expect(workspace.teams.single.dogPairs, hasLength(2));
      expect(workspace.teams.single.id, isNotEmpty);
      expect(
        workspace.teams.single.dogPairs.every((pair) => pair.id.isNotEmpty),
        isTrue,
      );
    });

    test(
      'updates team group level fields and toggles canPop to false',
      () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        await container.read(createTeamGroupProvider(null).future);

        final notifier = container.read(createTeamGroupProvider(null).notifier);
        final newDate = DateTime.utc(2026, 2, 3, 10, 45);

        notifier.changeName('Morning Run');
        notifier.changeNotes('Fresh snow');
        notifier.changeRunType(TeamGroupRunType.training);
        notifier.changeDate(newDate);
        notifier.changeDistance(18.5);

        final workspace = container
            .read(createTeamGroupProvider(null))
            .requireValue;
        expect(workspace.name, 'Morning Run');
        expect(workspace.notes, 'Fresh snow');
        expect(workspace.runType, TeamGroupRunType.training);
        expect(workspace.date, newDate);
        expect(workspace.distance, 18.5);
        expect(container.read(canPopTeamGroupProvider), isFalse);
      },
    );

    test('manages rows, team names, capacities and dog positions', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(createTeamGroupProvider(null).future);

      final notifier = container.read(createTeamGroupProvider(null).notifier);

      notifier.changeTeamName(teamNumber: 0, newName: 'Alpha');
      notifier.changePosition(
        dogId: 'dog-1',
        teamNumber: 0,
        rowNumber: 0,
        positionNumber: 0,
      );
      notifier.changePosition(
        dogId: 'dog-2',
        teamNumber: 0,
        rowNumber: 0,
        positionNumber: 1,
      );
      notifier.addRow(teamNumber: 0);
      notifier.changeTeamCapacity(teamNumber: 0, capacity: 3);
      notifier.removeRow(teamNumber: 0, rowNumber: 1);

      final workspace = container
          .read(createTeamGroupProvider(null))
          .requireValue;
      final team = workspace.teams.single;

      expect(team.name, 'Alpha');
      expect(team.capacity, 3);
      expect(team.dogPairs, hasLength(2));
      expect(team.dogPairs.first.firstDogId, 'dog-1');
      expect(team.dogPairs.first.secondDogId, 'dog-2');
    });

    test(
      'adds and removes teams while keeping the workspace consistent',
      () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        await container.read(createTeamGroupProvider(null).future);

        final notifier = container.read(createTeamGroupProvider(null).notifier);
        final initial = container
            .read(createTeamGroupProvider(null))
            .requireValue;
        final initialTeamId = initial.teams.first.id;

        notifier.addTeam(teamNumber: 1);
        var workspace = container
            .read(createTeamGroupProvider(null))
            .requireValue;
        expect(workspace.teams, hasLength(2));
        expect(workspace.teams[1].dogPairs, hasLength(3));

        notifier.removeTeam(teamNumber: 0);
        workspace = container.read(createTeamGroupProvider(null)).requireValue;
        expect(workspace.teams, hasLength(1));
        expect(workspace.teams.single.id, isNot(initialTeamId));
      },
    );
  });

  group('Derived create_team providers', () {
    test('runningDogsProvider returns unique assigned dog ids', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final runningDogs = container.read(
        runningDogsProvider(
          TeamGroupWorkspace(
            id: 'group-1',
            date: DateTime.utc(2026, 1, 1),
            teams: [
              TeamWorkspace(
                id: 'team-1',
                dogPairs: [
                  DogPairWorkspace(
                    id: 'pair-1',
                    firstDogId: 'dog-1',
                    secondDogId: 'dog-2',
                  ),
                  DogPairWorkspace(id: 'pair-2', firstDogId: 'dog-1'),
                ],
              ),
            ],
          ),
        ),
      );

      expect(runningDogs.toSet(), {'dog-1', 'dog-2'});
    });

    test('duplicateDogsProvider returns only duplicated dog ids', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(createTeamGroupProvider(null).future);

      final notifier = container.read(createTeamGroupProvider(null).notifier);
      notifier.changePosition(
        dogId: 'dog-1',
        teamNumber: 0,
        rowNumber: 0,
        positionNumber: 0,
      );
      notifier.changePosition(
        dogId: 'dog-1',
        teamNumber: 0,
        rowNumber: 1,
        positionNumber: 0,
      );
      notifier.changePosition(
        dogId: 'dog-2',
        teamNumber: 0,
        rowNumber: 1,
        positionNumber: 1,
      );

      expect(container.read(duplicateDogsProvider), ['dog-1']);
    });
  });

  group('CustomerAssign provider', () {
    test(
      'createCustomerGroup seeds a workspace and supports local edits',
      () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(customerAssignProvider(null).notifier);
        await container.read(customerAssignProvider(null).future);

        notifier.createCustomerGroup(
          dateTime: DateTime.utc(2026, 3, 4, 12),
          teamGroupId: 'team-group-1',
          tourTypeId: 'tour-1',
        );

        const originalCustomer = Customer(
          id: 'customer-1',
          bookingId: 'booking-1',
          name: 'Alex',
          teamId: 'team-a',
        );
        notifier.editCustomer(originalCustomer);
        notifier.editCustomer(originalCustomer.copyWith(teamId: 'team-b'));
        notifier.removeCustomersFromTeam('team-b');

        final workspace = container
            .read(customerAssignProvider(null))
            .requireValue;
        expect(workspace, isNotNull);
        expect(workspace!.customerGroup.teamGroupId, 'team-group-1');
        expect(workspace.customerGroup.tourTypeId, 'tour-1');
        expect(workspace.customers, hasLength(1));
        expect(workspace.customers.single.teamId, isNull);
      },
    );
  });
}
