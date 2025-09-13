import 'package:mush_on/services/error_handling.dart';

class BookingPageRepository {
  final String account;
  final String tourId;
  final logger = BasicLogger();

  BookingPageRepository({required this.account, required this.tourId});
}
