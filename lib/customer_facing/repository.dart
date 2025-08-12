import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mush_on/services/error_handling.dart';

class CustomerFacingRepository {
  final String account;
  CustomerFacingRepository({required this.account});

  Future<void> addCustomerFacingDogPic(
      {required String fileName,
      required File file,
      required String dogId}) async {
    final i = FirebaseStorage.instance;
    final storageRef =
        i.ref("accounts/$account/dogs/$dogId/customer_facing_pics/$fileName");
    try {
      await storageRef.putFile(file);
    } catch (e, s) {
      BasicLogger().error("Couldn't upload customer facing pic",
          error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteCustomerFacingDogPic(
      {required String fileName, required String dogId}) async {
    final i = FirebaseStorage.instance;
    final storageRef =
        i.ref("accounts/$account/dogs/$dogId/customer_facing_pics/$fileName");
    try {
      await storageRef.delete();
    } catch (e, s) {
      BasicLogger().error("Couldn't delete customer facing pic",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}
