import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_management/alert_editors/repository.dart';
import 'package:mush_on/customer_management/models.dart';

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
  group('AlertEditorsRepository refundBooking', () {
    test('calls refund_payment with account and booking id only', () async {
      final functions = _FakeFirebaseFunctions();
      final repository = AlertEditorsRepository(
        account: 'account-1',
        functions: functions,
      );
      const booking = Booking(id: 'booking-1', customerGroupId: 'cg-1');

      await repository.refundBooking(booking);

      expect(functions.calledName, 'refund_payment');
      expect(functions.callable.lastPayload, {
        'account': 'account-1',
        'bookingId': 'booking-1',
      });
      expect(functions.callable.lastPayload, isNot(contains('paymentIntent')));
      expect(functions.callable.lastPayload, isNot(contains('stripeAccount')));
    });

    test('rethrows cloud function failures', () async {
      final functions = _FakeFirebaseFunctions();
      final repository = AlertEditorsRepository(
        account: 'account-1',
        functions: functions,
      );
      functions.callable.exception = Exception('refund failed');

      expect(
        () => repository.refundBooking(
          const Booking(id: 'booking-1', customerGroupId: 'cg-1'),
        ),
        throwsException,
      );
    });
  });
}
