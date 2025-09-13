import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/services/error_handling.dart';

class BookingPageRepository {
  final String account;
  final String tourId;
  final logger = BasicLogger();

  BookingPageRepository({required this.account, required this.tourId});

  Future<List<CustomerGroup>> customerGroupsForTour(
      FirstAndLastDateInCalendar dates, String tourTypeId) async {
    final db = FirebaseFirestore.instance;
    final DateTime firstDate = dates.firstDate;
    final DateTime lastDate = dates.lastDate;
    final path = "accounts/$account/data/bookingManager/customerGroups";
    final collection = db
        .collection(path)
        .where("tourTypeId", isEqualTo: tourTypeId)
        .where("datetime", isGreaterThanOrEqualTo: firstDate)
        .where("datetime", isLessThan: lastDate.add(const Duration(days: 1)));
    try {
      final snapshot = await collection.get();
      return snapshot.docs
          .map((doc) => CustomerGroup.fromJson(doc.data()))
          .toList();
    } catch (e, s) {
      logger.error("Error fetching customer groups for tour $tourId",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}
