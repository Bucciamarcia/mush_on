import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_facing/booking_page/success/riverpod.dart';

void main() {
  group('pollWhileWaiting', () {
    Stream<String> poll(List<String> results, {int maxAttempts = 20}) {
      var calls = 0;
      return pollWhileWaiting<String>(
        () async => results[calls++],
        (status) => status == 'waiting',
        maxAttempts: maxAttempts,
        interval: Duration.zero,
      );
    }

    test('stops as soon as the booking is no longer waiting', () async {
      expect(
        await poll(['waiting', 'waiting', 'paid', 'unused']).toList(),
        ['waiting', 'waiting', 'paid'],
      );
    });

    test('does not poll a booking that is already paid', () async {
      expect(await poll(['paid', 'unused']).toList(), ['paid']);
    });

    test('gives up after maxAttempts', () async {
      expect(
        await poll(List.filled(10, 'waiting'), maxAttempts: 3).toList(),
        ['waiting', 'waiting', 'waiting'],
      );
    });

    test('a failed refresh keeps the last result and stops', () async {
      var calls = 0;
      final stream = pollWhileWaiting<String>(
        () async {
          calls++;
          if (calls == 2) throw Exception('network');
          return 'waiting';
        },
        (status) => status == 'waiting',
        interval: Duration.zero,
      );
      expect(await stream.toList(), ['waiting']);
    });

    test('a failure on the first fetch is reported', () async {
      final stream = pollWhileWaiting<String>(
        () async => throw Exception('network'),
        (status) => status == 'waiting',
        interval: Duration.zero,
      );
      expect(stream.toList(), throwsException);
    });
  });
}
