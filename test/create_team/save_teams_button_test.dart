import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/create_team/save_teams_button.dart';
import 'package:mush_on/create_team/teamgroup_snapshot.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/services/firestore.dart';

void main() {
  group('saveToDb', () {
    const account = 'account-1';
    final date = DateTime(2026, 1, 2, 10, 30);

    test('writes team group, teams snapshot, teams and dog pairs', () async {
      final firestore = FakeFirebaseFirestore();
      final teamGroup = _teamGroup(date: date);

      await saveToDb(teamGroup, account, null, firestore: firestore);

      final teamGroupSnapshot = await firestore
          .doc('accounts/$account/data/teams/history/tg-1')
          .get();
      final teamGroupData = teamGroupSnapshot.data()!;

      expect(teamGroupData['name'], 'Morning Run');
      expect(teamGroupData['teams'], isNull);
      expect(teamGroupData['teamsSnapshot'], contains('team-1'));
      expect(
        teamGroupData['teamsSnapshot']['team-1']['dogPairs'],
        contains('pair-1'),
      );
      expect(teamGroupData['teamsSnapshot']['team-1']['rank'], 0);
      expect(
        teamGroupData['teamsSnapshot']['team-1']['dogPairs']['pair-1']['rank'],
        0,
      );

      final teamSnapshot = await firestore
          .doc('accounts/$account/data/teams/history/tg-1/teams/team-1')
          .get();
      expect(teamSnapshot.data()!['rank'], 0);

      final dogPairSnapshot = await firestore
          .doc(
            'accounts/$account/data/teams/history/tg-1/teams/team-1/dogPairs/pair-1',
          )
          .get();
      expect(dogPairSnapshot.data()!['rank'], 0);
      expect(dogPairSnapshot.data()!['firstDogId'], 'dog-1');
    });

    test('keeps matching customer groups and clears stale links', () async {
      final firestore = FakeFirebaseFirestore();
      final teamGroup = _teamGroup(date: date);
      const path = 'accounts/$account/data/bookingManager/customerGroups';

      await firestore
          .doc('$path/cg-match')
          .set(
            CustomerGroup(
              id: 'cg-match',
              datetime: date,
              teamGroupId: teamGroup.id,
            ).toJson(),
          );
      await firestore
          .doc('$path/cg-stale')
          .set(
            CustomerGroup(
              id: 'cg-stale',
              datetime: date.add(const Duration(hours: 1)),
              teamGroupId: teamGroup.id,
            ).toJson(),
          );
      await firestore
          .doc('$path/cg-other-team')
          .set(
            CustomerGroup(
              id: 'cg-other-team',
              datetime: date.add(const Duration(hours: 1)),
              teamGroupId: 'other-team',
            ).toJson(),
          );

      await saveToDb(teamGroup, account, null, firestore: firestore);

      final matching = await firestore.doc('$path/cg-match').get();
      final stale = await firestore.doc('$path/cg-stale').get();
      final otherTeam = await firestore.doc('$path/cg-other-team').get();

      expect(matching.data()!['teamGroupId'], teamGroup.id);
      expect(stale.data()!['teamGroupId'], isNull);
      expect(otherTeam.data()!['teamGroupId'], 'other-team');
    });

    test('does not complete before customer group cleanup completes', () async {
      final firestore = FakeFirebaseFirestore();
      final cleanupStarted = Completer<void>();
      final cleanupRelease = Completer<void>();
      var saveCompleted = false;

      final saveFuture =
          saveToDb(
            _teamGroup(date: date),
            account,
            null,
            firestore: firestore,
            removeCustomerGroups: (_, _, _, _) {
              cleanupStarted.complete();
              return cleanupRelease.future;
            },
          ).then((_) {
            saveCompleted = true;
          });

      await cleanupStarted.future;
      await Future<void>.delayed(Duration.zero);

      expect(saveCompleted, isFalse);

      cleanupRelease.complete();
      await saveFuture;

      expect(saveCompleted, isTrue);
    });

    test('rethrows customer group cleanup failures', () async {
      final firestore = FakeFirebaseFirestore();

      expect(
        saveToDb(
          _teamGroup(date: date),
          account,
          null,
          firestore: firestore,
          removeCustomerGroups: (_, _, _, _) async {
            throw StateError('cleanup failed');
          },
        ),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('teamsFromSnapshot', () {
    test('restores ids and sorts teams and dog pairs by rank', () {
      final teams = teamsFromSnapshot({
        'team-wheel': {
          'name': 'Wheel sled',
          'capacity': 2,
          'rank': 1,
          'dogPairs': {
            'pair-wheel': {
              'firstDogId': 'dog-3',
              'secondDogId': 'dog-4',
              'rank': 1,
            },
            'pair-lead': {
              'firstDogId': 'dog-1',
              'secondDogId': 'dog-2',
              'rank': 0,
            },
          },
        },
        'team-lead': {
          'name': 'Lead guide',
          'capacity': 1,
          'rank': 0,
          'dogPairs': {},
        },
      });

      expect(teams.map((team) => team.id), ['team-lead', 'team-wheel']);
      expect(teams[1].dogPairs.map((pair) => pair.id), [
        'pair-lead',
        'pair-wheel',
      ]);
      expect(teams[1].dogPairs.first.firstDogId, 'dog-1');
    });

    test('rejects duplicate ranks instead of guessing order', () {
      expect(
        () => teamsFromSnapshot({
          'team-1': {'rank': 0, 'dogPairs': {}},
          'team-2': {'rank': 0, 'dogPairs': {}},
        }),
        throwsA(isA<TeamGroupSnapshotFormatException>()),
      );
    });
  });

  group('getTeamGroupWorkspace', () {
    const account = 'account-1';
    final date = DateTime(2026, 1, 2, 10, 30);

    test('uses valid teamsSnapshot before legacy subcollections', () async {
      final firestore = FakeFirebaseFirestore();
      await firestore.doc('accounts/$account/data/teams/history/tg-1').set({
        'id': 'tg-1',
        'name': 'Morning Run',
        'date': Timestamp.fromDate(date),
        'distance': 10,
        'notes': '',
        'runType': 'training',
        'teamsSnapshot': {
          'team-wheel': {
            'name': 'Wheel sled',
            'capacity': 2,
            'rank': 1,
            'dogPairs': {
              'pair-wheel': {
                'firstDogId': 'dog-3',
                'secondDogId': 'dog-4',
                'rank': 1,
              },
              'pair-lead': {
                'firstDogId': 'dog-1',
                'secondDogId': 'dog-2',
                'rank': 0,
              },
            },
          },
          'team-lead': {
            'name': 'Lead guide',
            'capacity': 1,
            'rank': 0,
            'dogPairs': {},
          },
        },
      });

      final workspace = await DogsDbOperations(
        firestore: firestore,
      ).getTeamGroupWorkspace(account: account, id: 'tg-1');

      expect(workspace.teams.map((team) => team.id), [
        'team-lead',
        'team-wheel',
      ]);
      expect(workspace.teams[1].dogPairs.map((pair) => pair.id), [
        'pair-lead',
        'pair-wheel',
      ]);
    });

    test(
      'falls back to legacy subcollections when snapshot is invalid',
      () async {
        final firestore = FakeFirebaseFirestore();
        const path = 'accounts/$account/data/teams/history/tg-1';
        await firestore.doc(path).set({
          'id': 'tg-1',
          'name': 'Morning Run',
          'date': Timestamp.fromDate(date),
          'distance': 10,
          'notes': '',
          'runType': 'training',
          'teamsSnapshot': {
            'team-bad': {
              'name': 'Bad snapshot',
              'rank': 'not-a-rank',
              'dogPairs': {},
            },
          },
        });
        await firestore.doc('$path/teams/team-wheel').set({
          'id': 'team-wheel',
          'name': 'Wheel sled',
          'capacity': 2,
          'rank': 1,
        });
        await firestore.doc('$path/teams/team-lead').set({
          'id': 'team-lead',
          'name': 'Lead guide',
          'capacity': 1,
          'rank': 0,
        });
        await firestore.doc('$path/teams/team-wheel/dogPairs/pair-wheel').set({
          'id': 'pair-wheel',
          'firstDogId': 'dog-3',
          'secondDogId': 'dog-4',
          'rank': 1,
        });
        await firestore.doc('$path/teams/team-wheel/dogPairs/pair-lead').set({
          'id': 'pair-lead',
          'firstDogId': 'dog-1',
          'secondDogId': 'dog-2',
          'rank': 0,
        });

        final workspace = await DogsDbOperations(
          firestore: firestore,
        ).getTeamGroupWorkspace(account: account, id: 'tg-1');

        expect(workspace.teams.map((team) => team.id), [
          'team-lead',
          'team-wheel',
        ]);
        expect(workspace.teams[1].dogPairs.map((pair) => pair.id), [
          'pair-lead',
          'pair-wheel',
        ]);
      },
    );
  });
}

TeamGroupWorkspace _teamGroup({required DateTime date}) {
  return TeamGroupWorkspace(
    id: 'tg-1',
    name: 'Morning Run',
    date: date,
    teams: const [
      TeamWorkspace(
        id: 'team-1',
        name: 'Alpha',
        dogPairs: [
          DogPairWorkspace(
            id: 'pair-1',
            firstDogId: 'dog-1',
            secondDogId: 'dog-2',
          ),
        ],
      ),
    ],
  );
}
