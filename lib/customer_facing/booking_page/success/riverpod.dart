import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@riverpod
Future<(Booking, List<Customer>, CustomerGroup, List<TourTypePricing>)>
bookingDataSuccess(
  Ref ref, {
  required String bookingId,
  required String account,
}) async {
  final instance = FirebaseFunctions.instanceFor(region: "europe-north1");
  final response = await instance
      .httpsCallable("get_booking_success_data")
      .call({"account": account, "bookingId": bookingId});
  final data = _decodeCallableTimestamps(
    response.data as Map<Object?, Object?>,
  );
  final booking = Booking.fromJson(
    Map<String, dynamic>.from(data["booking"] as Map),
  );
  final customers = (data["customers"] as List)
      .map((customer) => Customer.fromJson(Map<String, dynamic>.from(customer)))
      .toList();
  final cg = CustomerGroup.fromJson(
    Map<String, dynamic>.from(data["customerGroup"] as Map),
  );
  final pricings = (data["pricings"] as List)
      .map(
        (pricing) =>
            TourTypePricing.fromJson(Map<String, dynamic>.from(pricing)),
      )
      .toList();
  return (booking, customers, cg, pricings);
}

@riverpod
Future<UrlAndAmount> receiptUrl(
  Ref ref, {
  required String account,
  required String bookingId,
}) async {
  final instance = FirebaseFunctions.instanceFor(region: "europe-north1");
  try {
    final response = await instance
        .httpsCallable("stripe_get_payment_receipt_url")
        .call({"account": account, "bookingId": bookingId});
    final data = response.data as Map<String, dynamic>;
    return UrlAndAmount(url: data["url"], amount: data["total"]);
  } catch (e, s) {
    BasicLogger().error("Couldn't get receipt url", error: e, stackTrace: s);
    rethrow;
  }
}

@freezed
sealed class UrlAndAmount with _$UrlAndAmount {
  const factory UrlAndAmount({required String url, required int amount}) =
      _UrlAndAmount;
}

dynamic _decodeCallableTimestamps(dynamic value) {
  if (value is Map) {
    final millis = value["_millisecondsSinceEpoch"];
    if (millis is num) {
      return Timestamp.fromMillisecondsSinceEpoch(millis.toInt());
    }
    return value.map(
      (key, innerValue) =>
          MapEntry(key.toString(), _decodeCallableTimestamps(innerValue)),
    );
  }
  if (value is List) {
    return value.map(_decodeCallableTimestamps).toList();
  }
  return value;
}
