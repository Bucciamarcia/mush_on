import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_facing/confirm_invitation/repository.dart';

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
  Object? exception;

  @override
  Future<HttpsCallableResult<T>> call<T>([dynamic parameters]) async {
    if (exception != null) {
      throw exception!;
    }
    lastPayload = Map<String, dynamic>.from(parameters as Map);
    return _FakeHttpsCallableResult<T>();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpsCallableResult<T> implements HttpsCallableResult<T> {
  @override
  T get data => null as dynamic;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ConfirmInvitationRepository', () {
    test(
      'acceptInvitation calls accept_invitation with invite identifiers',
      () async {
        final functions = _FakeFirebaseFunctions();
        final repository = ConfirmInvitationRepository(functions: functions);

        await repository.acceptInvitation(
          email: 'new.user@example.com',
          securityCode: 'code-1',
        );

        expect(functions.calledName, 'accept_invitation');
        expect(functions.callable.lastPayload, {
          'email': 'new.user@example.com',
          'securityCode': 'code-1',
        });
      },
    );

    test('acceptInvitation rethrows cloud function failures', () async {
      final functions = _FakeFirebaseFunctions();
      final repository = ConfirmInvitationRepository(functions: functions);
      functions.callable.exception = Exception('Exception triggered');

      expect(
        () => repository.acceptInvitation(
          email: 'new.user@example.com',
          securityCode: 'code-1',
        ),
        throwsException,
      );
    });
  });
}
