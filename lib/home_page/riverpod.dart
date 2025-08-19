import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import 'models.dart';
part 'riverpod.g.dart';

@riverpod

/// Just for the home page
Stream<HomePageRiverpodResults> homePageRiverpod(Ref ref) async* {
  yield* Rx.combineLatest5(dogs(ref), tasks(ref, null), healthEvents(ref, null),
      heatCycles(ref, null), todayWhiteboard(ref), (b, c, d, e, f) {
    return HomePageRiverpodResults(
        dogs: b,
        tasks: c,
        healthEvents: d,
        heatCycles: e,
        whiteboardElements: f);
  });
}

@riverpod

/// Streams the list of today's whiteboard elements from the db.
Stream<List<WhiteboardElement>> todayWhiteboard(Ref ref) async* {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/homePage/whiteboardElements";
  final db = FirebaseFirestore.instance;
  var dbRef = db
      .collection(path)
      .where(
        "date",
        isGreaterThanOrEqualTo: DateTimeUtils.today(),
      )
      .where(
        "date",
        isLessThan: DateTimeUtils.today().add(
          const Duration(days: 1),
        ),
      );
  yield* dbRef.snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => WhiteboardElement.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );
}
