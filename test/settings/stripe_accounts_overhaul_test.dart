// Failing tests describing the Stripe account archival / reconnection overhaul
// (logic + repository layer). They are the executable spec for
// `stripe_config_worksheet.md` and are expected NOT to compile / pass against
// the current code base. They pass once the worksheet is implemented.
//
// Run: flutter test test/settings/stripe_accounts_overhaul_test.dart

import 'package:cloud_functions/cloud_functions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/settings/stripe/stripe_account_selectors.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'package:mush_on/settings/stripe/stripe_repository.dart';

class _FakeFirebaseFunctions implements FirebaseFunctions {
  final List<String> calledNames = [];
  final _FakeHttpsCallable callable = _FakeHttpsCallable();

  @override
  HttpsCallable httpsCallable(String name, {HttpsCallableOptions? options}) {
    calledNames.add(name);
    callable.lastName = name;
    return callable;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpsCallable implements HttpsCallable {
  String? lastName;
  Map<String, dynamic>? lastPayload;
  Map<String, dynamic> response = {};

  @override
  Future<HttpsCallableResult<T>> call<T>([dynamic parameters]) async {
    lastPayload = Map<String, dynamic>.from(parameters as Map);
    return _FakeHttpsCallableResult<T>(response);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpsCallableResult<T> implements HttpsCallableResult<T> {
  final T _data;
  _FakeHttpsCallableResult(Object data) : _data = data as T;

  @override
  T get data => _data;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFirebaseStorage implements FirebaseStorage {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

StripeRepository _repository(
  _FakeFirebaseFunctions functions, {
  FakeFirebaseFirestore? firestore,
}) {
  return StripeRepository(
    account: 'account-1',
    functions: functions,
    firestore: firestore ?? FakeFirebaseFirestore(),
    storage: _FakeFirebaseStorage(),
  );
}

void main() {
  group('StripeAccount model', () {
    test('parses a connected subcollection document', () {
      final account = StripeAccount.fromJson(const {
        'accountId': 'acct_test',
        'mode': 'test',
        'archived': false,
      });

      expect(account.accountId, 'acct_test');
      expect(account.mode, StripeMode.test);
      expect(account.archived, isFalse);
    });

    test('archived defaults to false', () {
      final account = StripeAccount.fromJson(const {
        'accountId': 'acct_test',
        'mode': 'live',
      });

      expect(account.mode, StripeMode.live);
      expect(account.archived, isFalse);
    });
  });

  group('stripe account selectors', () {
    const testConnected = StripeAccount(
      accountId: 'acct_test_connected',
      mode: StripeMode.test,
      archived: false,
    );
    const testArchivedA = StripeAccount(
      accountId: 'acct_test_old_a',
      mode: StripeMode.test,
      archived: true,
    );
    const testArchivedB = StripeAccount(
      accountId: 'acct_test_old_b',
      mode: StripeMode.test,
      archived: true,
    );
    const liveConnected = StripeAccount(
      accountId: 'acct_live_connected',
      mode: StripeMode.live,
      archived: false,
    );

    final all = [testConnected, testArchivedA, testArchivedB, liveConnected];

    test('connectedAccountForMode returns the single non-archived account', () {
      expect(connectedAccountForMode(all, StripeMode.test), testConnected);
      expect(connectedAccountForMode(all, StripeMode.live), liveConnected);
    });

    test('connectedAccountForMode returns null when only archived exist', () {
      expect(
        connectedAccountForMode(const [
          testArchivedA,
          testArchivedB,
        ], StripeMode.test),
        isNull,
      );
    });

    test('archivedAccountsForMode returns only archived for that mode', () {
      final archivedTest = archivedAccountsForMode(all, StripeMode.test);
      expect(
        archivedTest.map((a) => a.accountId),
        containsAll(['acct_test_old_a', 'acct_test_old_b']),
      );
      expect(archivedTest, isNot(contains(testConnected)));
      expect(archivedTest, isNot(contains(liveConnected)));
      expect(archivedAccountsForMode(all, StripeMode.live), isEmpty);
    });
  });

  group('StripeRepository commands', () {
    test('setSelectedMode persists the chosen mode', () async {
      final functions = _FakeFirebaseFunctions();
      await _repository(functions).setSelectedMode(StripeMode.live);

      expect(functions.calledNames, contains('set_selected_stripe_mode'));
      expect(functions.callable.lastPayload, {
        'account': 'account-1',
        'stripeMode': 'live',
      });
    });

    test('reconnectStripeAccount sends accountId and mode', () async {
      final functions = _FakeFirebaseFunctions();
      await _repository(functions).reconnectStripeAccount(
        accountId: 'acct_history',
        stripeMode: StripeMode.test,
      );

      expect(functions.calledNames, contains('reconnect_stripe_account'));
      expect(functions.callable.lastPayload, {
        'account': 'account-1',
        'accountId': 'acct_history',
        'stripeMode': 'test',
      });
    });

    test('deleteStripeAccount sends the targeted accountId', () async {
      final functions = _FakeFirebaseFunctions();
      await _repository(functions).deleteStripeAccount(accountId: 'acct_drop');

      expect(functions.calledNames, contains('delete_stripe_account'));
      expect(functions.callable.lastPayload, {
        'account': 'account-1',
        'accountId': 'acct_drop',
      });
    });

    test('disconnectStripeAccount sends the selected mode', () async {
      final functions = _FakeFirebaseFunctions();
      await _repository(
        functions,
      ).disconnectStripeAccount(stripeMode: StripeMode.live);

      expect(functions.calledNames, contains('disconnect_stripe_account'));
      expect(functions.callable.lastPayload, {
        'account': 'account-1',
        'stripeMode': 'live',
      });
    });
  });

  group('StripeRepository streams', () {
    test('selectedMode stream emits the persisted mode', () async {
      final firestore = FakeFirebaseFirestore();
      await firestore.doc('accounts/account-1/integrations/stripe').set({
        'selectedMode': 'live',
      });

      final repository = _repository(
        _FakeFirebaseFunctions(),
        firestore: firestore,
      );

      await expectLater(repository.selectedMode(), emits(StripeMode.live));
    });

    test(
      'stripeAccounts stream emits connected and archived accounts',
      () async {
        final firestore = FakeFirebaseFirestore();
        final col = firestore.collection(
          'accounts/account-1/integrations/stripe/accounts',
        );
        await col.doc('acct_connected').set({
          'accountId': 'acct_connected',
          'mode': 'test',
          'archived': false,
          'isActive': true,
        });
        await col.doc('acct_old').set({
          'accountId': 'acct_old',
          'mode': 'test',
          'archived': true,
          'isActive': false,
        });

        final repository = _repository(
          _FakeFirebaseFunctions(),
          firestore: firestore,
        );

        final accounts = await repository.stripeAccounts().first;
        expect(
          accounts.map((a) => a.accountId),
          containsAll(['acct_connected', 'acct_old']),
        );
        expect(
          accounts.firstWhere((a) => a.accountId == 'acct_connected').archived,
          isFalse,
        );
        expect(
          accounts.firstWhere((a) => a.accountId == 'acct_old').archived,
          isTrue,
        );
      },
    );
  });
}
