import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'package:mush_on/settings/stripe/stripe_repository.dart';
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

@riverpod
class KennelImage extends _$KennelImage {
  @override
  Future<Uint8List?> build() async {
    final account = await ref.read(accountProvider.future);
    final data = await StripeRepository(account: account).getKennelImage();
    return data;
  }

  void change(Uint8List? newPic) {
    state = AsyncValue.data(newPic);
  }
}

@riverpod
Stream<BookingManagerKennelInfo?> bookingManagerKennelInfo(Ref ref) async* {
  final account = await ref.watch(accountProvider.future);
  final path = "accounts/$account/data/bookingManager";
  final db = FirebaseFirestore.instance;
  final doc = db.doc(path);
  yield* doc.snapshots().map((snapshot) {
    final data = snapshot.data();
    if (data == null) {
      return null;
    }
    return BookingManagerKennelInfo.fromJson(data);
  });
}
