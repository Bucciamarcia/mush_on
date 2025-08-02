import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/custom_converters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@freezed
sealed class TeamGroupWorkspace with _$TeamGroupWorkspace {
  const factory TeamGroupWorkspace({
    @Default("") String id,

    /// The name of the entire group.
    @Default("") String name,
    @NonNullableTimestampConverter() required DateTime date,

    /// The distance ran in km.
    /// Used for stats.
    @Default(0) double distance,
    @Default("") String notes,
    @Default([]) List<TeamWorkspace> teams,
  }) = _TeamGroupWorkspace;
  factory TeamGroupWorkspace.fromJson(Map<String, dynamic> json) =>
      _$TeamGroupWorkspaceFromJson(json);
}

@freezed
sealed class TeamWorkspace with _$TeamWorkspace {
  const factory TeamWorkspace({
    /// Internal name of the team
    @Default("") String name,

    /// Uuid
    required String id,

    /// How many customers this team can carry
    @Default(0) int capacity,
    @Default([]) List<DogPairWorkspace> dogPairs,
  }) = _TeamWorkspace;
  factory TeamWorkspace.fromJson(Map<String, dynamic> json) =>
      _$TeamWorkspaceFromJson(json);
}

@freezed
sealed class DogPairWorkspace with _$DogPairWorkspace {
  const factory DogPairWorkspace({
    String? firstDogId,
    String? secondDogId,
    required String id,
  }) = _DogPairWorkspace;
  factory DogPairWorkspace.fromJson(Map<String, dynamic> json) =>
      _$DogPairWorkspaceFromJson(json);
}

@riverpod
class CanPopTeamGroup extends _$CanPopTeamGroup {
  @override
  bool build() {
    return true;
  }

  void changeState(bool n) {
    state = n;
  }
}

@freezed

/// Incldues all the customer groups, bookings and customers involved in this teamgroup.
sealed class CustomerGroupWorkspace with _$CustomerGroupWorkspace {
  const factory CustomerGroupWorkspace({
    required CustomerGroup customerGroup,
    @Default([]) List<Booking> bookings,

    /// All customers by customer group ID.
    @Default([]) List<Customer> customers,
  }) = _CustomerGroupWorkspace;
}

@riverpod
class CustomerAssign extends _$CustomerAssign {
  @override
  Future<CustomerGroupWorkspace?> build(String? teamGroupId) async {
    if (teamGroupId == null) {
      return null;
    }
    CustomerGroup? customerGroup =
        await ref.watch(customerGroupForTeamgroupProvider(teamGroupId).future);
    if (customerGroup == null) {
      return null;
    }
    List<Booking> bookings = [];
    List<Customer> customers = [];
    var b = await ref
        .watch(bookingsByCustomerGroupIdProvider(customerGroup.id).future);
    bookings.addAll(b);
    customers.addAll(await ref
        .watch(customersByCustomerGroupIdProvider(customerGroup.id).future));
    return CustomerGroupWorkspace(
      customerGroup: customerGroup,
      bookings: bookings,
      customers: customers,
    );
  }

  void createCustomerGroup(
      {required DateTime dateTime, required String teamGroupId}) {
    state = state.whenData(
      (data) => CustomerGroupWorkspace(
        customerGroup: CustomerGroup(
          teamGroupId: teamGroupId,
          datetime: dateTime,
          id: Uuid().v4(),
        ),
      ),
    );
  }

  /// Edits a customer by removing it and adding it again via id.
  ///
  /// Note: will always put the new customer at the bottom.
  void editCustomer(Customer customer) {
    state = state.whenData(
      (data) => data!.copyWith(
        customers: [
          ...data.customers.where((c) => c.id != customer.id),
          customer,
        ],
      ),
    );
  }

  void removeCustomersFromTeam(String teamId) {
    var logger = BasicLogger();
    logger.info("Removing customers from team: $teamId");
    state = state.whenData(
      (data) {
        if (data == null) {
          return null;
        }
        List<Customer> customers = data.customers;
        List<Customer> newCustomers = [];
        for (var customer in customers) {
          if (customer.teamId == teamId) {
            newCustomers.add(customer.copyWith(teamId: null));
          } else {
            newCustomers.add(customer);
          }
        }
        return data.copyWith(customers: newCustomers);
      },
    );
  }
}

@riverpod

/// The teamgroup that is being built.
class CreateTeamGroup extends _$CreateTeamGroup {
  @override
  Future<TeamGroupWorkspace> build(String? teamGroupId) async {
    if (teamGroupId == null) {
      return TeamGroupWorkspace(
        date: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateTime.now().hour,
          DateTime.now().minute,
        ),
        id: Uuid().v4(),
        teams: [
          TeamWorkspace(id: Uuid().v4(), dogPairs: [
            DogPairWorkspace(id: Uuid().v4()),
            DogPairWorkspace(id: Uuid().v4()),
          ]),
        ],
      );
    } else {
      String account = await ref.watch(accountProvider.future);
      return await DogsDbOperations()
          .getTeamGroupWorkspace(account: account, id: teamGroupId);
    }
  }

  /// Change name of the teamgroup.
  void changeName(String newName) async {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.whenData((data) => data.copyWith(name: newName));
  }

  void changeNotes(String newNotes) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.whenData((data) => data.copyWith(notes: newNotes));
  }

  void changeDate(DateTime newDate) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.whenData((data) => data.copyWith(date: newDate));
  }

  void changeDistance(double newDistance) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.whenData((data) => data.copyWith(distance: newDistance));
  }

  /// Changes a dog in a certain position with another dog.
  void changePosition({
    required String dogId,
    required int teamNumber,
    required int rowNumber,
    required int positionNumber,
  }) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    // More efficient update pattern
    state = state.whenData(
      (data) => data.copyWith(
        teams: [
          for (int i = 0; i < data.teams.length; i++)
            if (i == teamNumber)
              data.teams[i].copyWith(
                dogPairs: [
                  for (int j = 0; j < data.teams[i].dogPairs.length; j++)
                    if (j == rowNumber)
                      positionNumber == 0
                          ? data.teams[i].dogPairs[j]
                              .copyWith(firstDogId: dogId)
                          : data.teams[i].dogPairs[j]
                              .copyWith(secondDogId: dogId)
                    else
                      data.teams[i].dogPairs[j]
                ],
              )
            else
              data.teams[i]
        ],
      ),
    );
  }

  void changeTeamName({required int teamNumber, required String newName}) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.whenData(
      (data) => data.copyWith(
        teams: [
          for (int i = 0; i < data.teams.length; i++)
            if (i == teamNumber)
              data.teams[i].copyWith(name: newName)
            else
              data.teams[i]
        ],
      ),
    );
  }

  void removeRow({required int teamNumber, required int rowNumber}) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.whenData((data) => data.copyWith(
          teams: [
            for (int i = 0; i < data.teams.length; i++)
              if (i == teamNumber)
                data.teams[i].copyWith(
                  dogPairs: [
                    for (int j = 0; j < data.teams[i].dogPairs.length; j++)
                      if (j != rowNumber) data.teams[i].dogPairs[j]
                  ],
                )
              else
                data.teams[i]
          ],
        ));
  }

  /// Adds a row at the end of the team.
  void addRow({required int teamNumber}) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.whenData((data) {
      var teamToEdit = data.teams[teamNumber];
      var newRows =
          List<DogPairWorkspace>.from(data.teams[teamNumber].dogPairs);
      newRows.add(DogPairWorkspace(id: Uuid().v4()));
      var editedTeam = teamToEdit.copyWith(dogPairs: newRows);
      var newTeams = List<TeamWorkspace>.from(data.teams);
      newTeams.removeAt(teamNumber);
      newTeams.insert(teamNumber, editedTeam);
      return data.copyWith(teams: newTeams);
    });
  }

  void addTeam({required int teamNumber}) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.whenData((data) {
      var newTeams = List<TeamWorkspace>.from(data.teams);
      newTeams.insert(
        teamNumber,
        TeamWorkspace(dogPairs: [
          DogPairWorkspace(id: Uuid().v4()),
          DogPairWorkspace(id: Uuid().v4()),
          DogPairWorkspace(id: Uuid().v4()),
        ], id: Uuid().v4()),
      );
      return data.copyWith(teams: newTeams);
    });
  }

  void changeTeamCapacity({required int teamNumber, required int capacity}) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.whenData((data) {
      var newTeams = List<TeamWorkspace>.from(data.teams);
      var teamToEdit = newTeams[teamNumber];
      newTeams[teamNumber] = teamToEdit.copyWith(capacity: capacity);
      return data.copyWith(teams: newTeams);
    });
  }

  void removeTeam({required int teamNumber}) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.whenData((data) {
      String teamId = data.teams[teamNumber].id;
      ref
          .read(customerAssignProvider(data.id).notifier)
          .removeCustomersFromTeam(teamId);
      var newTeams = List<TeamWorkspace>.from(data.teams);
      newTeams.removeAt(teamNumber);
      return data.copyWith(teams: newTeams);
    });
  }
}

@riverpod

/// The ids of the dogs that are currently running.
///
/// Used to make the unavailable in the dropdown selection.
class RunningDogs extends _$RunningDogs {
  @override
  List<String> build(TeamGroupWorkspace group) {
    // Use a Set for O(1) lookups
    final dogSet = <String>{};

    for (final team in group.teams) {
      for (final row in team.dogPairs) {
        if (row.firstDogId != null) {
          dogSet.add(row.firstDogId!);
        }
        if (row.secondDogId != null) {
          dogSet.add(row.secondDogId!);
        }
      }
    }

    return dogSet.toList();
  }
}

@riverpod
List<String> duplicateDogs(Ref ref) {
  final teamGroup = ref.watch(createTeamGroupProvider(null)).value;
  if (teamGroup == null) {
    return [];
  }

  // Count occurrences in a single pass
  final dogCounts = <String, int>{};

  for (final team in teamGroup.teams) {
    for (final row in team.dogPairs) {
      if (row.firstDogId != null) {
        dogCounts[row.firstDogId!] = (dogCounts[row.firstDogId!] ?? 0) + 1;
      }
      if (row.secondDogId != null) {
        dogCounts[row.secondDogId!] = (dogCounts[row.secondDogId!] ?? 0) + 1;
      }
    }
  }

  // Filter duplicates
  return dogCounts.entries
      .where((entry) => entry.value > 1)
      .map((entry) => entry.key)
      .toList();
}

@riverpod
Future<TeamGroup?> teamGroupById(Ref ref, String id) async {
  BasicLogger().debug("Getting teamgroup by id: $id");
  var db = FirebaseFirestore.instance;
  String account = await ref.watch(accountProvider.future);
  var doc = db.doc("accounts/$account/data/teams/history/$id");
  try {
    var snapshot = await doc.get();
    var data = snapshot.data();
    BasicLogger().debug("teamgroup by id: $data");
    if (data == null) {
      throw Exception("Data is empty");
    } else {
      return TeamGroup.fromJson(data);
    }
  } catch (e, s) {
    BasicLogger().error(
      "Error getting team group by id: $id",
      error: e,
      stackTrace: s,
    );
    return null;
  }
}

@riverpod

/// Gets all the customer groups assigned to this teamgroup.
Stream<CustomerGroup?> customerGroupForTeamgroup(
    Ref ref, String teamGroupId) async* {
  final db = FirebaseFirestore.instance;
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/bookingManager/customerGroups";
  final collection =
      db.collection(path).where("teamGroupId", isEqualTo: teamGroupId);
  yield* collection.snapshots().map((snapshot) => snapshot.docs
      .map(
        (doc) => CustomerGroup.fromJson(
          doc.data(),
        ),
      )
      .firstOrNull);
}
