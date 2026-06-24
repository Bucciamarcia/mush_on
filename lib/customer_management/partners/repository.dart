import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/customer_management/partners/models.dart';

class PartnersRepository {
  final String account;
  final FirebaseFirestore db;
  PartnersRepository({required this.account, FirebaseFirestore? db})
    : db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col => db
      .collection('accounts')
      .doc(account)
      .collection('data')
      .doc('bookingManager')
      .collection('partners');

  /// Upsert. The doc id MUST equal partner.id, and `id` MUST also be written
  /// as a field (so Dart code never relies on doc.id alone).
  Future<void> savePartner(Partner partner) =>
      _col.doc(partner.id).set(partner.toJson());

  /// Archive — never delete.
  Future<void> archivePartner(String partnerId) =>
      _col.doc(partnerId).update({'archived': true});

  Future<List<Partner>> fetchPartners() async {
    final snap = await _col.get();
    return snap.docs.map((d) => Partner.fromJson(d.data())).toList();
  }
}
