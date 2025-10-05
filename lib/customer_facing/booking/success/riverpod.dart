import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/customer_facing/booking/success/repository.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod
Future<(Booking, List<Customer>, CustomerGroup)> bookingDataSuccess(Ref ref,
    {required String bookingId, required String account}) async {
  final repo = SuccessPageRepository();
  final (booking, customers) = await (
    repo.fetchBooking(account, bookingId),
    repo.fetchCustomers(account, bookingId)
  ).wait;
  final cg = await repo.fetchCg(account, booking.customerGroupId);
  return (booking, customers, cg);
}
