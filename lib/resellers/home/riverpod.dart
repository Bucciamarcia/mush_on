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
