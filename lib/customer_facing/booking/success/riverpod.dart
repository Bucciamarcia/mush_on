import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/customer_facing/booking/success/repository.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@riverpod
Future<(Booking, List<Customer>, CustomerGroup, List<TourTypePricing>)>
    bookingDataSuccess(Ref ref,
        {required String bookingId, required String account}) async {
  final repo = SuccessPageRepository();
  final (booking, customers) = await (
    repo.fetchBooking(account, bookingId),
    repo.fetchCustomers(account, bookingId)
  ).wait;
  final cg = await repo.fetchCg(account, booking.customerGroupId);
  final pricings = cg.tourTypeId == null
      ? <TourTypePricing>[]
      : await ref.watch(tourTypePricesByTourIdProvider(
              account: account, tourId: cg.tourTypeId!)
          .future);
  return (booking, customers, cg, pricings);
}

@riverpod
Future<UrlAndAmount> receiptUrl(Ref ref, String bookingId) async {
  final instance = FirebaseFunctions.instanceFor(region: "europe-north1");
  try {
    final response = await instance
        .httpsCallable("stripe_get_payment_receipt_url")
        .call({"bookingId": bookingId});
    final data = response.data as Map<String, dynamic>;
    return UrlAndAmount(url: data["url"], amount: data["total"]);
  } catch (e, s) {
    BasicLogger().error("Couldn't get receipt url", error: e, stackTrace: s);
    rethrow;
  }
}

@freezed
sealed class UrlAndAmount with _$UrlAndAmount {
  const factory UrlAndAmount({
    required String url,
    required int amount,
  }) = _UrlAndAmount;
}
