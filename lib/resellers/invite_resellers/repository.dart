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
      String uid, String email, String account) async {
    final path = "users/$uid";
    final doc = db.doc(path);
    final snap = await doc.get();
    final data = snap.data();

    // Create user doc if it doesn't exist
    if (data == null) {
      final payload = Reseller(accounts: [account], email: email, uid: uid);
      await doc.set(payload.toJson());
      return;
    }

    // If it exists, add the account to the list if it isn't there
    final accounts = data["accounts"] as List<String>?;
    if (accounts == null) {
      await doc.update({
        "accounts": [account]
      });
      return;
    }
    await doc.update({
      "accounts": [...accounts, account]
    });
  }
}

@freezed

/// A reseller. Just like a user (in the same path),
/// but with resellers.
sealed class Reseller with _$Reseller {
  const factory Reseller({
    required String uid,
    required String email,

    /// The account names associated with this reseller
    required List<String> accounts,
  }) = _Reseller;

  factory Reseller.fromJson(Map<String, dynamic> json) =>
      _$ResellerFromJson(json);
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
