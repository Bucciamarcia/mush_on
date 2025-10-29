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
Future<BookingDetailsDataFetch> bookingDetailsDataFetch(Ref ref) async {
  final resellerUser = await ref.watch(userProvider.future);
  final resellerData = await ref.watch(resellerDataProvider.future);
  final resellerSettings =
      await ref.watch(resellerSettingsAsyncProvider.future);
  final accountToResell = await ref.watch(accountToResellProvider.future);
  return BookingDetailsDataFetch(
      resellerUser: resellerUser,
      resellerData: resellerData,
      resellerSettings: resellerSettings,
      accountToResell: accountToResell);
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
