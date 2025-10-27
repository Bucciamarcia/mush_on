import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'repository.freezed.dart';
part 'repository.g.dart';

class InviteResellerRepository {
  final db = FirebaseFirestore.instance;
  final functions = FirebaseFunctions.instanceFor(region: "europe-north1");

  /// Fetches a reseller invitation by email
  Future<ResellerInvitation?> getInvitation(String email) async {
    final path = "resellerInvitations/$email";
    final doc = db.doc(path);
    final snap = await doc.get();
    final data = snap.data();
    if (data == null) return null;
    return ResellerInvitation.fromJson(data);
  }

  Future<void> onResellerSignin(
      String uid, String email, String account, int discountAmount) async {
    final path = "users/$uid";
    final doc = db.doc(path);
    final snap = await doc.get();
    final data = snap.data();

    // Create user doc if it doesn't exist
    if (data == null) {
      final payload = Reseller(resellerAccounts: [
        AccountAndDiscount(
            accountName: account, discountAmount: discountAmount / 100)
      ], email: email, uid: uid);
      await doc.set(payload.toJson());
      return;
    }

    // If it exists, add the account to the list if it isn't there
    final accountsData = data["resellerAccounts"] as List<dynamic>?;

    if (accountsData == null) {
      await doc.update({
        "resellerAccounts": [
          // Changed key
          AccountAndDiscount(
                  accountName: account, discountAmount: discountAmount / 100)
              .toJson()
        ]
      });
      return;
    }

    // Parse existing accounts and check for duplicates
    final existingAccounts = accountsData
        .map((e) => AccountAndDiscount.fromJson(e as Map<String, dynamic>))
        .toList();

    // Check if account already exists
    if (existingAccounts.any((a) => a.accountName == account)) {
      return;
    }

    await doc.update({
      "resellerAccounts": [
        // Changed key
        ...accountsData,
        AccountAndDiscount(
                accountName: account, discountAmount: discountAmount / 100)
            .toJson()
      ]
    });
  }
}

@freezed

/// A reseller. Just like a user (in the same path),
/// but with resellers.
sealed class Reseller with _$Reseller {
  @JsonSerializable(explicitToJson: true)
  const factory Reseller({
    required String uid,
    required String email,

    /// The account names associated with this reseller
    required List<AccountAndDiscount> resellerAccounts,
  }) = _Reseller;

  factory Reseller.fromJson(Map<String, dynamic> json) =>
      _$ResellerFromJson(json);
}

@freezed

/// The account name this guy reselles, with the amount of the discount
sealed class AccountAndDiscount with _$AccountAndDiscount {
  const factory AccountAndDiscount({
    /// The name of the account being resold
    required String accountName,

    /// The amount of the discount in %, eg. 0.15 for 15%
    required double discountAmount,
  }) = _AccountAndDiscount;

  factory AccountAndDiscount.fromJson(Map<String, dynamic> json) =>
      _$AccountAndDiscountFromJson(json);
}

@freezed
sealed class ResellerInvitation with _$ResellerInvitation {
  const factory ResellerInvitation({
    required bool accepted,
    required String account,
    required int discount,
    required String email,
    required String securityCode,
  }) = _ResellerInvitation;

  factory ResellerInvitation.fromJson(Map<String, dynamic> json) =>
      _$ResellerInvitationFromJson(json);
}
