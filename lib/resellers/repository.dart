import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/resellers/home/riverpod.dart';

class ResellerRepository {
  final db = FirebaseFirestore.instance;
  final functions = FirebaseFunctions.instanceFor(region: "europe-north1");

  Future<void> makeResellerBooking(
      {required List<BookedSpot> bookedSpots,
      required CustomerGroup customerGroup,
      required List<Customer> existingCustomers}) async {
    if (_isCustomerGroupFull(bookedSpots, customerGroup, existingCustomers)) {
      throw GroupAlreadyFullException(
          "Trying to book ${bookedSpots.number} in a group of max ${customerGroup.maxCapacity}, but ${existingCustomers.length} already booked");
    }
  }

  bool _isCustomerGroupFull(List<BookedSpot> bookedSpots,
      CustomerGroup customerGroup, List<Customer> existingCustomers) {
    int existingCustomersNumber = existingCustomers.length;
    int maxCapacity = customerGroup.maxCapacity;
    int tryingToBookNumber = bookedSpots.number;
    if (existingCustomersNumber + tryingToBookNumber > maxCapacity) {
      return true;
    } else {
      return false;
    }
  }
}

class GroupAlreadyFullException implements Exception {
  String cause;
  GroupAlreadyFullException(this.cause);

  @override
  String toString() => "GroupAlreadyFullException: $cause";
}
