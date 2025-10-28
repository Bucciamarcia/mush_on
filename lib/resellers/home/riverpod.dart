import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/resellers/create_account/riverpod.dart';
import 'package:mush_on/resellers/invite_resellers/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

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

@riverpod
class VisibleDates extends _$VisibleDates {
  @override
  List<DateTime> build() {
    return [];
  }

  void change(List<DateTime> v) {
    if (state != v) state = v;
  }
}
