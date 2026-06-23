import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_facing/booking_page/repository.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/partners/models.dart';

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
  Map<String, dynamic> result = {
    'url': 'https://checkout.test/session',
    'bookingId': 'booking-1',
  };

  @override
  Future<HttpsCallableResult<T>> call<T>([dynamic parameters]) async {
    lastPayload = Map<String, dynamic>.from(parameters as Map);
    return _FakeHttpsCallableResult<T>(result);
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

void main() {
  const booking = Booking(
    id: 'booking-1',
    customerGroupId: 'cg-1',
    email: 'customer@example.com',
  );
  const customers = [
    Customer(id: 'customer-1', bookingId: '', name: 'Ada', pricingId: 'adult'),
  ];
  const partner = Partner(
    id: 'partner-1',
    code: 'acme',
    allowDeferred: true,
    discountRate: 0.1,
  );

  group('BookingPageRepository partner forwarding', () {
    test('getStripePaymentUrl forwards the partner id when present', () async {
      final functions = _FakeFirebaseFunctions();
      final repository = BookingPageRepository(
        account: 'account-1',
        tourId: 'tour-1',
        functions: functions,
      );

      await repository.getStripePaymentUrl(
        booking: booking,
        customers: customers,
        partner: partner,
      );

      expect(functions.calledName, 'create_booking_checkout_session');
      expect(functions.callable.lastPayload!['partner'], 'partner-1');
    });

    test('getStripePaymentUrl omits partner when none is given', () async {
      final functions = _FakeFirebaseFunctions();
      final repository = BookingPageRepository(
        account: 'account-1',
        tourId: 'tour-1',
        functions: functions,
      );

      await repository.getStripePaymentUrl(
        booking: booking,
        customers: customers,
      );

      // No partner -> the payload must not carry a (null) partner key.
      expect(functions.callable.lastPayload!.containsKey('partner'), false);
    });
  });

  group('BookingPageRepository.createDeferredBooking', () {
    test('calls create_deferred_booking with the partner id', () async {
      final functions = _FakeFirebaseFunctions();
      final repository = BookingPageRepository(
        account: 'account-1',
        tourId: 'tour-1',
        functions: functions,
      );

      final bookingId = await repository.createDeferredBooking(
        booking: booking,
        customers: customers,
        partner: partner,
      );

      expect(bookingId, 'booking-1');
      expect(functions.calledName, 'create_deferred_booking');
      final payload = functions.callable.lastPayload!;
      expect(payload['account'], 'account-1');
      expect(payload['tourId'], 'tour-1');
      expect(payload['partner'], 'partner-1');
      expect(payload.containsKey('booking'), true);
      expect(payload.containsKey('customers'), true);
    });
  });
}
</content>
