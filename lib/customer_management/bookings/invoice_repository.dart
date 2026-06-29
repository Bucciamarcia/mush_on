import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mush_on/customer_management/bookings/invoice_models.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/partners/models.dart';
import 'package:mush_on/services/error_handling.dart';

class BookingInvoicesRepository {
  final String account;
  final FirebaseFirestore firestore;
  final FirebaseFunctions functions;
  final logger = BasicLogger();

  BookingInvoicesRepository({
    required this.account,
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
  }) : firestore = firestore ?? FirebaseFirestore.instance,
       functions =
           functions ?? FirebaseFunctions.instanceFor(region: 'europe-north1');

  String get _bookingManagerPath => 'accounts/$account/data/bookingManager';

  Stream<List<Booking>> watchBookings() {
    return firestore
        .collection('$_bookingManagerPath/bookings')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Booking.fromJson(doc.data())).toList(),
        );
  }

  Stream<List<CustomerGroup>> watchCustomerGroups() {
    return firestore
        .collection('$_bookingManagerPath/customerGroups')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CustomerGroup.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<Partner>> watchPartners() {
    return firestore
        .collection('$_bookingManagerPath/partners')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Partner.fromJson(doc.data())).toList(),
        );
  }

  Stream<List<InvoiceSummary>> watchInvoices() {
    return firestore
        .collection('$_bookingManagerPath/invoices')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => InvoiceSummary.fromJson(doc.data(), id: doc.id))
              .toList(),
        );
  }

  Stream<InvoiceDetails?> watchInvoice(String bookingId) {
    return firestore
        .doc('$_bookingManagerPath/invoices/$bookingId')
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();
          if (data == null) return null;
          return InvoiceDetails.fromJson(data, id: snapshot.id);
        });
  }

  Future<InvoiceSummary> generateInvoice({
    required String bookingId,
    required InvoiceRecipientDetails recipient,
  }) async {
    try {
      final response = await functions
          .httpsCallable('generate_invoice_for_booking')
          .call({
            'account': account,
            'bookingId': bookingId,
            'recipient': recipient.toJson(),
          });
      final data = Map<String, dynamic>.from(response.data as Map);
      final invoice = Map<String, dynamic>.from(data['invoice'] as Map);
      return InvoiceSummary.fromJson(invoice, id: bookingId);
    } catch (e, s) {
      logger.error('Failed to generate invoice', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> sendInvoiceEmail({
    required String bookingId,
    required String email,
  }) async {
    try {
      await functions.httpsCallable('send_invoice_email').call({
        'account': account,
        'bookingId': bookingId,
        'email': email.trim(),
      });
    } catch (e, s) {
      logger.error('Failed to send invoice email', error: e, stackTrace: s);
      rethrow;
    }
  }

  static Future<InvoiceDetails> getPublicInvoice({
    required String account,
    required String bookingId,
    required String token,
    FirebaseFunctions? functions,
  }) async {
    final callableFunctions =
        functions ?? FirebaseFunctions.instanceFor(region: 'europe-north1');
    final response = await callableFunctions
        .httpsCallable('get_public_invoice')
        .call({'account': account, 'bookingId': bookingId, 'token': token});
    final data = Map<String, dynamic>.from(response.data as Map);
    final invoice = Map<String, dynamic>.from(data['invoice'] as Map);
    return InvoiceDetails.fromJson(invoice, id: bookingId);
  }
}
