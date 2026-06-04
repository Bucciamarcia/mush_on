import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/create_team/save_teams_button.dart';
import 'package:mush_on/customer_management/models.dart';

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
