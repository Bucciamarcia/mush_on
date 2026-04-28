import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_facing/booking_page/repository.dart';
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

  @override
  Future<HttpsCallableResult<T>> call<T>([dynamic parameters]) async {
    lastPayload = Map<String, dynamic>.from(parameters as Map);
    return _FakeHttpsCallableResult<T>({
      'url': 'https://checkout.test/session',
    });
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
  group('BookingPageRepository', () {
    test(
      'creates checkout with non-authoritative booking selections only',
      () async {
        final functions = _FakeFirebaseFunctions();
        final repository = BookingPageRepository(
          account: 'account-1',
          tourId: 'tour-1',
          functions: functions,
        );
        const booking = Booking(
          id: 'booking-1',
          customerGroupId: 'cg-1',
          name: '',
          email: 'customer@example.com',
          phone: '123',
        );
        const customers = [
          Customer(
            id: 'customer-1',
            bookingId: '',
            name: 'Ada',
            pricingId: 'adult',
          ),
          Customer(
            id: 'customer-2',
            bookingId: '',
            name: 'Grace',
            pricingId: 'child',
          ),
        ];

        final url = await repository.getStripePaymentUrl(
          booking: booking,
          customers: customers,
        );

        expect(url, 'https://checkout.test/session');
        expect(functions.calledName, 'create_booking_checkout_session');
        final payload = functions.callable.lastPayload!;
        expect(
          payload.keys,
          containsAll(['account', 'tourId', 'booking', 'customers']),
        );
        expect(payload.keys, isNot(contains('lineItems')));
        expect(payload.keys, isNot(contains('total')));
        expect(payload.keys, isNot(contains('totalAmount')));
        expect(payload.keys, isNot(contains('feeAmount')));
        expect(payload.keys, isNot(contains('commission')));
        expect(payload.keys, isNot(contains('paymentIntent')));
        expect(payload.keys, isNot(contains('paymentIntentId')));
        expect(payload.keys, isNot(contains('stripeAccount')));
        expect(payload.keys, isNot(contains('stripeAccountId')));
        expect(payload.keys, isNot(contains('stripeId')));
        expect(payload.keys, isNot(contains('checkoutSessionId')));

        final bookingPayload = Map<String, dynamic>.from(
          payload['booking'] as Map,
        );
        expect(bookingPayload['id'], 'booking-1');
        expect(bookingPayload['customerGroupId'], 'cg-1');
        expect(bookingPayload['name'], 'Ada');
        expect(bookingPayload['paymentStatus'], 'waiting');
        expect(bookingPayload.keys, isNot(contains('total')));
        expect(bookingPayload.keys, isNot(contains('commission')));
        expect(bookingPayload.keys, isNot(contains('paymentIntentId')));
        expect(bookingPayload.keys, isNot(contains('stripeId')));
        expect(bookingPayload.keys, isNot(contains('checkoutSessionId')));

        final customerPayloads = (payload['customers'] as List)
            .map((customer) => Map<String, dynamic>.from(customer as Map))
            .toList();
        expect(customerPayloads, hasLength(2));
        expect(customerPayloads.first['bookingId'], 'booking-1');
        for (final customerPayload in customerPayloads) {
          expect(customerPayload.keys, isNot(contains('total')));
          expect(customerPayload.keys, isNot(contains('commission')));
          expect(customerPayload.keys, isNot(contains('paymentIntentId')));
          expect(customerPayload.keys, isNot(contains('stripeId')));
          expect(customerPayload.keys, isNot(contains('checkoutSessionId')));
        }
      },
    );
  });
}
