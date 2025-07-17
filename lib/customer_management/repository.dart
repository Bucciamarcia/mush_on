import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerManagementRepository {
  final _db = FirebaseFirestore.instance;
  final String account;
  CustomerManagementRepository({required this.account});

  Future<void> addBooking() async {}
}
