import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/resellers/create_account/riverpod.dart';
import 'package:mush_on/resellers/invite_resellers/repository.dart';
import 'package:mush_on/resellers/models.dart';
import 'package:mush_on/resellers/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@Riverpod(keepAlive: true)
class AccountToResell extends _$AccountToResell {
  @override
  Future<AccountAndDiscount?> build() async {
    final reseller = await ref.watch(resellerProvider.future);
    if (reseller == null) {
      throw Exception("No reseller found");
    }
    final accounts = reseller.resellerAccounts;
    if (accounts.isEmpty) return null;
    return accounts[0];
  }

  void change(AccountAndDiscount v) {
    state = state.whenData((data) {
      return v;
    });
  }
}

@riverpod
Future<List<TourType>> tourTypes(Ref ref, String account) async {
  final functions = FirebaseFunctions.instanceFor(region: "europe-north1");
  final response = await functions
      .httpsCallable("get_firebase_collection")
      .call({"path": "accounts/$account/data/bookingManager/tours"});
  final data = (response.data as List<dynamic>)
      .map((e) => Map<String, dynamic>.from(e as Map))
      .toList();
  return data.map((tour) => TourType.fromJson(tour)).toList();
}

@Riverpod(keepAlive: true)

/// The CG selected by the reseller for booking tours.
class SelectedCustomerGroup extends _$SelectedCustomerGroup {
  @override
  CustomerGroup? build() {
    return null;
  }

  void change(CustomerGroup? v) {
    state = v;
  }
}

@riverpod

/// Fetches the reseller settings, but needs to go thorugh a function this time.
Future<ResellerSettings?> resellerSettingsAsync(Ref ref) async {
  final logger = BasicLogger();
  final accountToResell = await ref.watch(accountToResellProvider.future);
  if (accountToResell == null) {
    throw Exception("There must be an account to resell!");
  }
  final path =
      "accounts/${accountToResell.accountName}/data/settings/resellers/settings";
  logger.debug(path);
  final functions = FirebaseFunctions.instanceFor(region: "europe-north1");
  try {
    final response = await functions
        .httpsCallable("get_firebase_document")
        .call({"path": path});
    return ResellerSettings.fromJson(response.data);
  } catch (e, s) {
    logger.error("Couldn't get reseller settings async",
        error: e, stackTrace: s);
    return null;
  }
}

@riverpod
class BookedSpots extends _$BookedSpots {
  @override
  List<BookedSpot> build(List<TourTypePricing> prices) {
    var toReturn = <BookedSpot>[];
    for (final p in prices) {
      toReturn.add(BookedSpot(pricing: p, number: 0));
    }
    return toReturn;
  }

  void changeOne(TourTypePricing pricing, int value) {
    var toReturn = List<BookedSpot>.from(state);
    toReturn.removeWhere((bs) => bs.pricing.id == pricing.id);
    toReturn.add(BookedSpot(pricing: pricing, number: value));
    state = toReturn;
  }
}

@riverpod
class PayNowPreference extends _$PayNowPreference {
  @override
  bool build() {
    return true;
  }

  void change(bool v) {
    state = v;
  }
}

@freezed
sealed class BookedSpot with _$BookedSpot {
  const factory BookedSpot({
    required TourTypePricing pricing,
    required int number,
  }) = _BookedSpot;
}

extension BookedSpotListExtension on List<BookedSpot> {
  int get number {
    var toReturn = 0;
    for (final bs in this) {
      toReturn = toReturn + bs.number;
    }
    return toReturn;
  }
}

@riverpod
Future<BookingDetailsDataFetch> bookingDetailsDataFetch(Ref ref) async {
  final results = await Future.wait([
    ref.watch(userProvider.future),
    ref.watch(resellerDataProvider.future),
    ref.watch(resellerSettingsAsyncProvider.future),
    ref.watch(accountToResellProvider.future),
  ]);
  return BookingDetailsDataFetch(
      resellerUser: results[0] as User?,
      resellerData: results[1] as ResellerData?,
      resellerSettings: results[2] as ResellerSettings?,
      accountToResell: results[3] as AccountAndDiscount?);
}

@riverpod
class NameOnBooking extends _$NameOnBooking {
  @override
  String build() {
    return "";
  }

  void change(String v) {
    state = v;
  }
}

@riverpod
class OtherNotes extends _$OtherNotes {
  @override
  String build() {
    return "";
  }

  void change(String v) {
    state = v;
  }
}

@freezed
sealed class BookingDetailsDataFetch with _$BookingDetailsDataFetch {
  const factory BookingDetailsDataFetch({
    required User? resellerUser,
    required ResellerData? resellerData,
    required ResellerSettings? resellerSettings,
    required AccountAndDiscount? accountToResell,
  }) = _BookingDetailsDataFetch;
}
