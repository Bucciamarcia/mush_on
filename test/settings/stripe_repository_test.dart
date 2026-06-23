import 'package:cloud_functions/cloud_functions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'package:mush_on/settings/stripe/stripe_repository.dart';

class _FakeFirebaseFunctions implements FirebaseFunctions {
  String? calledName;
  final _FakeHttpsCallable callable = _FakeHttpsCallable();

  @override
  HttpsCallable httpsCallable(String name, {HttpsCallableOptions? options}) {
    calledName = name;
    return callable;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpsCallable implements HttpsCallable {
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

void main() {
  group('StripeRepository', () {
    test(
      'changeStripeIntegrationActivation updates the global active flag',
      () async {
        final functions = _FakeFirebaseFunctions();
        final repository = StripeRepository(
          account: 'account-1',
          functions: functions,
          firestore: FakeFirebaseFirestore(),
          storage: _FakeFirebaseStorage(),
        );

        await repository.changeStripeIntegrationActivation(true);

        expect(functions.calledName, 'change_stripe_integration_activation');
        expect(functions.callable.lastPayload, {
          'account': 'account-1',
          'isActive': true,
        });
      },
    );

    test('disconnectActiveStripeConnection calls backend cleanup', () async {
      final functions = _FakeFirebaseFunctions();
      final repository = StripeRepository(
        account: 'account-1',
        functions: functions,
        firestore: FakeFirebaseFirestore(),
        storage: _FakeFirebaseStorage(),
      );

      await repository.disconnectActiveStripeConnection();

      expect(functions.calledName, 'disconnect_stripe_account');
      expect(functions.callable.lastPayload, {'account': 'account-1'});
    });

    test('finalizeStripeOnboarding sends attempt token to backend', () async {
      final functions = _FakeFirebaseFunctions();
      functions.callable.response = {'isActive': true};
      final repository = StripeRepository(
        account: 'account-1',
        functions: functions,
        firestore: FakeFirebaseFirestore(),
        storage: _FakeFirebaseStorage(),
      );

      final isActive = await repository.finalizeStripeOnboarding(
        attemptId: 'attempt-1',
        token: 'token-1',
      );

      expect(isActive, isTrue);
      expect(functions.calledName, 'finalize_stripe_onboarding');
      expect(functions.callable.lastPayload, {
        'account': 'account-1',
        'attemptId': 'attempt-1',
        'token': 'token-1',
      });
    });

    test('createStripeAccount sends selected mode', () async {
      final functions = _FakeFirebaseFunctions();
      functions.callable.response = {'account': 'acct_123'};
      final repository = StripeRepository(
        account: 'account-1',
        functions: functions,
        firestore: FakeFirebaseFirestore(),
        storage: _FakeFirebaseStorage(),
      );

      final accountId = await repository.createStripeAccount(
        stripeMode: StripeMode.test,
      );

      expect(accountId, 'acct_123');
      expect(functions.calledName, 'stripe_create_account');
      expect(functions.callable.lastPayload, {
        'account': 'account-1',
        'stripeMode': 'test',
      });
    });

    test('createStripeAccountLink requests a fresh onboarding link', () async {
      final functions = _FakeFirebaseFunctions();
      functions.callable.response = {'url': 'https://connect.stripe.test'};
      final repository = StripeRepository(
        account: 'account-1',
        functions: functions,
        firestore: FakeFirebaseFirestore(),
        storage: _FakeFirebaseStorage(),
      );

      final url = await repository.createStripeAccountLink(
        stripeMode: StripeMode.live,
      );

      expect(url, 'https://connect.stripe.test');
      expect(functions.calledName, 'stripe_create_account_link');
      expect(functions.callable.lastPayload, {
        'account': 'account-1',
        'stripeMode': 'live',
      });
    });

    test('getStripeConnectionStatus parses backend readiness', () async {
      final functions = _FakeFirebaseFunctions();
      functions.callable.response = {
        'activeMode': 'test',
        'hasAccount': true,
        'isReady': false,
        'chargesEnabled': false,
        'payoutsEnabled': false,
        'detailsSubmitted': false,
        'disabledReason': 'requirements.past_due',
        'reason': 'Stripe needs more account information.',
      };
      final repository = StripeRepository(
        account: 'account-1',
        functions: functions,
        firestore: FakeFirebaseFirestore(),
        storage: _FakeFirebaseStorage(),
      );

      final status = await repository.getStripeConnectionStatus();

      expect(functions.calledName, 'get_stripe_connection_status');
      expect(functions.callable.lastPayload, {'account': 'account-1'});
      expect(status.hasAccount, isTrue);
      expect(status.isReady, isFalse);
      expect(status.disabledReason, 'requirements.past_due');
      expect(status.reason, 'Stripe needs more account information.');
    });
  });
}
