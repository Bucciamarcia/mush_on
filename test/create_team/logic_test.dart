import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/customers/main.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/create_team/team_builder/main.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/kennel/dog/main.dart';
import 'package:mush_on/kennel/dog/riverpod.dart' as dog_riverpod;
import 'package:mush_on/riverpod.dart' as app_riverpod;
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/shared/distance_warning_widget/riverpod.dart';
import 'package:mush_on/shared/dog_filter/main.dart';
import 'package:searchfield/searchfield.dart';

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
              const TeamWorkspace(
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

      final workspace = container
          .read(createTeamGroupProvider(null))
          .requireValue;

      expect(container.read(duplicateDogsProvider(workspace)), ['dog-1']);
    });

    test(
      'duplicateDogsProvider returns empty when selected dog ids are unique',
      () async {
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
          dogId: 'dog-2',
          teamNumber: 0,
          rowNumber: 0,
          positionNumber: 1,
        );

        final workspace = container
            .read(createTeamGroupProvider(null))
            .requireValue;

        expect(container.read(duplicateDogsProvider(workspace)), isEmpty);
      },
    );

    testWidgets(
      'default workspace duplicate still shows a duplicate dog note',
      (tester) async {
        final date = DateTime.utc(2026, 1, 1);
        final teamGroup = _teamGroupWithDogs(
          id: 'new-group',
          date: date,
          firstDogIds: ['dog-1', 'dog-1'],
        );

        await tester.pumpWidget(
          _teamBuilderHarness(
            teamGroup: teamGroup,
            providerKey: null,
            dogs: _dogs,
            overrides: [
              createTeamGroupProvider(
                null,
              ).overrideWith(() => _TestCreateTeamGroup(teamGroup)),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Duplicate dog!'), findsWidgets);
      },
    );

    testWidgets(
      'loaded workspace duplicate shows a duplicate dog note even when new workspace is clean',
      (tester) async {
        final date = DateTime.utc(2026, 1, 1);
        final loadedTeamGroup = _teamGroupWithDogs(
          id: 'loaded-group',
          date: date,
          firstDogIds: ['dog-1', 'dog-1'],
        );
        final cleanNewTeamGroup = _teamGroupWithDogs(
          id: 'new-group',
          date: date,
          firstDogIds: ['dog-2', 'dog-3'],
        );

        await tester.pumpWidget(
          _teamBuilderHarness(
            teamGroup: loadedTeamGroup,
            providerKey: loadedTeamGroup.id,
            dogs: _dogs,
            overrides: [
              createTeamGroupProvider(
                null,
              ).overrideWith(() => _TestCreateTeamGroup(cleanNewTeamGroup)),
              createTeamGroupProvider(
                loadedTeamGroup.id,
              ).overrideWith(() => _TestCreateTeamGroup(loadedTeamGroup)),
              customerAssignProvider(
                loadedTeamGroup.id,
              ).overrideWith(_TestCustomerAssign.new),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Duplicate dog!'), findsWidgets);
      },
    );

    testWidgets(
      'loaded workspace without duplicates does not show duplicate dog notes from new workspace',
      (tester) async {
        final date = DateTime.utc(2026, 1, 1);
        final loadedTeamGroup = _teamGroupWithDogs(
          id: 'loaded-group',
          date: date,
          firstDogIds: ['dog-2', 'dog-3'],
        );
        final duplicateNewTeamGroup = _teamGroupWithDogs(
          id: 'new-group',
          date: date,
          firstDogIds: ['dog-1', 'dog-1'],
        );

        await tester.pumpWidget(
          _teamBuilderHarness(
            teamGroup: loadedTeamGroup,
            providerKey: loadedTeamGroup.id,
            dogs: _dogs,
            overrides: [
              createTeamGroupProvider(
                null,
              ).overrideWith(() => _TestCreateTeamGroup(duplicateNewTeamGroup)),
              createTeamGroupProvider(
                loadedTeamGroup.id,
              ).overrideWith(() => _TestCreateTeamGroup(loadedTeamGroup)),
              customerAssignProvider(
                loadedTeamGroup.id,
              ).overrideWith(_TestCustomerAssign.new),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Duplicate dog!'), findsNothing);
      },
    );

    testWidgets('team builder dog selectors show all dogs before filtering', (
      tester,
    ) async {
      final date = DateTime.utc(2026, 1, 1);
      final teamGroup = _teamGroupWithDogs(
        id: 'new-group',
        date: date,
        firstDogIds: [''],
      );

      await tester.pumpWidget(
        _teamBuilderHarness(
          teamGroup: teamGroup,
          providerKey: null,
          dogs: _dogs,
          overrides: [
            createTeamGroupProvider(
              null,
            ).overrideWith(() => _TestCreateTeamGroup(teamGroup)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        _selectorSuggestionLabels(tester),
        containsAll(['Alpha', 'Beta', 'Gamma']),
      );
    });

    testWidgets('team builder dog filter updates empty selector options', (
      tester,
    ) async {
      final date = DateTime.utc(2026, 1, 1);
      final teamGroup = _teamGroupWithDogs(
        id: 'new-group',
        date: date,
        firstDogIds: [''],
      );

      await tester.pumpWidget(
        _teamBuilderHarness(
          teamGroup: teamGroup,
          providerKey: null,
          dogs: _dogs,
          overrides: [
            createTeamGroupProvider(
              null,
            ).overrideWith(() => _TestCreateTeamGroup(teamGroup)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await _applyDogFilter(tester, [_dogs[1]]);
      await tester.pumpAndSettle();

      expect(_selectorSuggestionLabels(tester), ['Beta']);
    });

    testWidgets(
      'team builder dog filter does not remove an already selected dog',
      (tester) async {
        final date = DateTime.utc(2026, 1, 1);
        final teamGroup = _teamGroupWithDogs(
          id: 'new-group',
          date: date,
          firstDogIds: ['dog-1'],
        );

        await tester.pumpWidget(
          _teamBuilderHarness(
            teamGroup: teamGroup,
            providerKey: null,
            dogs: _dogs,
            overrides: [
              createTeamGroupProvider(
                null,
              ).overrideWith(() => _TestCreateTeamGroup(teamGroup)),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await _applyDogFilter(tester, [_dogs[1]]);
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('DogSelectedChip - dog-1')),
          findsOneWidget,
        );
        expect(_selectorSuggestionLabels(tester), ['Beta']);
      },
    );

    testWidgets('selected dog chip opens the kennel dog page in a popup', (
      tester,
    ) async {
      final date = DateTime.utc(2026, 1, 1);
      final teamGroup = _teamGroupWithDogs(
        id: 'new-group',
        date: date,
        firstDogIds: ['dog-1'],
      );

      await tester.pumpWidget(
        _teamBuilderHarness(
          teamGroup: teamGroup,
          providerKey: null,
          dogs: _dogs,
          overrides: [
            createTeamGroupProvider(
              null,
            ).overrideWith(() => _TestCreateTeamGroup(teamGroup)),
            app_riverpod.accountProvider.overrideWith(
              (ref) => Stream.value('account-1'),
            ),
            app_riverpod
                .tasksProvider(null)
                .overrideWith((ref) => Stream.value(const TasksInMemory())),
            dog_riverpod
                .singleDogProvider('dog-1')
                .overrideWith((ref) => Stream.value(_dogs.first)),
            dog_riverpod
                .singleDogImageProvider('account-1', 'dog-1')
                .overrideWith(_TestSingleDogImage.new),
            dog_riverpod
                .dogTotalProvider(dogId: 'dog-1', cutoff: null)
                .overrideWith((ref) => Stream.value([])),
            dog_riverpod
                .dogHealthEventsProvider(dogId: 'dog-1', cutoff: null)
                .overrideWith((ref) => Stream.value([])),
            dog_riverpod
                .dogVaccinationsProvider(dogId: 'dog-1', cutoff: null)
                .overrideWith((ref) => Stream.value([])),
            dog_riverpod
                .dogHeatsProvider(dogId: 'dog-1', cutoff: null)
                .overrideWith((ref) => Stream.value([])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('DogSelectedChip - dog-1')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextButton, 'Close'), findsOneWidget);
      final dogMain = tester.widget<DogMain>(find.byType(DogMain));
      expect(dogMain.dogId, 'dog-1');
      expect(dogMain.showDeleteButton, isFalse);
    });

    testWidgets(
      'team builder empty dog filter result shows all dogs and error',
      (tester) async {
        final date = DateTime.utc(2026, 1, 1);
        final teamGroup = _teamGroupWithDogs(
          id: 'new-group',
          date: date,
          firstDogIds: [''],
        );

        await tester.pumpWidget(
          _teamBuilderHarness(
            teamGroup: teamGroup,
            providerKey: null,
            dogs: _dogs,
            overrides: [
              createTeamGroupProvider(
                null,
              ).overrideWith(() => _TestCreateTeamGroup(teamGroup)),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await _applyDogFilter(tester, []);
        await tester.pump();

        expect(
          _selectorSuggestionLabels(tester),
          containsAll(['Alpha', 'Beta', 'Gamma']),
        );
        expect(
          find.text('Search came up empty. Showing all dogs'),
          findsOneWidget,
        );
      },
    );
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

  group('CustomerActionChip', () {
    testWidgets('available customer tap selects the customer', (tester) async {
      var selectedCount = 0;
      var deselectedCount = 0;

      await tester.pumpWidget(
        _customerChipHarness(
          customer: const Customer(
            id: 'customer-1',
            bookingId: 'booking-1',
            name: 'Alex',
          ),
          teamId: 'team-a',
          onCustomerSelected: () => selectedCount++,
          onCustomerDeselected: () => deselectedCount++,
        ),
      );

      expect(find.text('Available'), findsOneWidget);

      await tester.tap(find.text('customer - 1'));
      await tester.pump();

      expect(selectedCount, 1);
      expect(deselectedCount, 0);
    });

    testWidgets('customer on this sled can be removed', (tester) async {
      var selectedCount = 0;
      var deselectedCount = 0;

      await tester.pumpWidget(
        _customerChipHarness(
          customer: const Customer(
            id: 'customer-1',
            bookingId: 'booking-1',
            name: 'Alex',
            teamId: 'team-a',
          ),
          teamId: 'team-a',
          onCustomerSelected: () => selectedCount++,
          onCustomerDeselected: () => deselectedCount++,
        ),
      );

      expect(find.text('On this sled'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.cancel_outlined));
      await tester.pump();

      expect(selectedCount, 0);
      expect(deselectedCount, 1);
    });

    testWidgets('customer on another sled needs explicit move confirmation', (
      tester,
    ) async {
      var selectedCount = 0;
      var deselectedCount = 0;

      await tester.pumpWidget(
        _customerChipHarness(
          customer: const Customer(
            id: 'customer-1',
            bookingId: 'booking-1',
            name: 'Alex',
            teamId: 'team-b',
          ),
          teamId: 'team-a',
          onCustomerSelected: () => selectedCount++,
          onCustomerDeselected: () => deselectedCount++,
        ),
      );

      expect(find.text('On another sled'), findsOneWidget);
      expect(find.text('Move here'), findsOneWidget);

      await tester.tap(find.text('customer - 1'));
      await tester.pump();

      expect(selectedCount, 0);
      expect(deselectedCount, 0);
      expect(find.text('Move customer?'), findsNothing);

      await tester.tap(find.text('Move here'));
      await tester.pumpAndSettle();

      expect(find.text('Move customer?'), findsOneWidget);
      expect(find.text('Move customer - 1 to this sled?'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(selectedCount, 0);
      expect(deselectedCount, 0);

      await tester.tap(find.text('Move here'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Move here'));
      await tester.pumpAndSettle();

      expect(selectedCount, 1);
      expect(deselectedCount, 0);
    });
  });
}

const _dogs = [
  Dog(id: 'dog-1', name: 'Alpha'),
  Dog(id: 'dog-2', name: 'Beta'),
  Dog(id: 'dog-3', name: 'Gamma'),
];

List<String> _selectorSuggestionLabels(WidgetTester tester) {
  final searchFields = tester.widgetList<SearchField<Dog>>(
    find.byType(SearchField<Dog>),
  );
  return searchFields
      .expand(
        (field) => field.suggestions.map((suggestion) => suggestion.searchKey),
      )
      .toSet()
      .toList()
    ..sort();
}

Future<void> _applyDogFilter(WidgetTester tester, List<Dog> dogs) async {
  await tester.tap(find.text('Filter dogs'));
  await tester.pumpAndSettle();
  tester.widget<DogFilterWidget>(find.byType(DogFilterWidget)).onResult(dogs);
}

Widget _customerChipHarness({
  required Customer customer,
  required String teamId,
  required VoidCallback onCustomerSelected,
  required VoidCallback onCustomerDeselected,
}) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: CustomerActionChip(
          customer: customer,
          teamId: teamId,
          booking: Booking(id: customer.bookingId, customerGroupId: 'group-1'),
          pricings: const <TourTypePricing>[],
          allCustomers: [customer],
          onCustomerSelected: onCustomerSelected,
          onCustomerDeselected: onCustomerDeselected,
        ),
      ),
    ),
  );
}

TeamGroupWorkspace _teamGroupWithDogs({
  required String id,
  required DateTime date,
  required List<String> firstDogIds,
}) {
  return TeamGroupWorkspace(
    id: id,
    date: date,
    teams: [
      TeamWorkspace(
        id: '$id-team',
        dogPairs: [
          for (final (index, dogId) in firstDogIds.indexed)
            DogPairWorkspace(id: '$id-pair-$index', firstDogId: dogId),
        ],
      ),
    ],
  );
}

Widget _teamBuilderHarness({
  required TeamGroupWorkspace teamGroup,
  required String? providerKey,
  required List<Dog> dogs,
  required List<Override> overrides,
}) {
  return ProviderScope(
    overrides: [
      app_riverpod.dogsProvider.overrideWith((ref) => Stream.value(dogs)),
      app_riverpod.settingsProvider.overrideWith(
        (ref) => Stream.value(const SettingsModel()),
      ),
      distanceWarningsProvider(
        latestDate: teamGroup.date,
      ).overrideWith((ref) => Stream.value([])),
      healthEventsProvider(365).overrideWith((ref) => Stream.value([])),
      heatCyclesProvider(60).overrideWith((ref) => Stream.value([])),
      ...overrides,
    ],
    child: MaterialApp(
      home: Scaffold(
        body: Consumer(
          builder: (context, ref, child) {
            final dogsReady = ref.watch(app_riverpod.dogsProvider).hasValue;
            if (!dogsReady) {
              return const SizedBox.shrink();
            }
            return TeamBuilderWidget(
              teamGroup: teamGroup,
              customerGroupWorkspace: CustomerGroupWorkspace(
                customerGroup: CustomerGroup(
                  id: 'customer-group',
                  datetime: teamGroup.date,
                  tourTypeId: 'tour',
                ),
              ),
              providerKey: providerKey,
            );
          },
        ),
      ),
    ),
  );
}

class _TestCreateTeamGroup extends CreateTeamGroup {
  _TestCreateTeamGroup(this.teamGroup);

  final TeamGroupWorkspace teamGroup;

  @override
  Future<TeamGroupWorkspace> build(String? teamGroupId) async => teamGroup;
}

class _TestCustomerAssign extends CustomerAssign {
  @override
  Future<CustomerGroupWorkspace?> build(String? teamGroupId) async => null;
}

class _TestSingleDogImage extends dog_riverpod.SingleDogImage {
  @override
  Future<Null> build(String account, String dogId) async => null;
}
