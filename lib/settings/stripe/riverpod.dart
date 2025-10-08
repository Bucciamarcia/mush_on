import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod
Stream<StripeConnection?> stripeConnection(Ref ref) async* {
  final String account = await ref.watch(accountProvider.future);
  final db = FirebaseFirestore.instance;
  String path = "accounts/$account/integrations/stripe";
  final doc = db.doc(path);
  yield* doc.snapshots().map((snapshot) {
    final data = snapshot.data();
    if (data == null) return null;
    return StripeConnection.fromJson(data);
  });
}
