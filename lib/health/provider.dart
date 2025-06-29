import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
Stream<List<HealthEvent>> healthEvents(Ref ref, int? cutOff) async* {
  var db = FirebaseFirestore.instance;
  String account = await ref.watch(accountProvider.future);
  var cutoffDays = DateTimeUtils.today().subtract(Duration(days: cutOff ?? 30));
  String path = "accounts/$account/data/kennel/healthEvents";
  var collection = db.collection(path);
  var query = collection.where("createdAt", isGreaterThanOrEqualTo: cutoffDays);
  yield* query.snapshots().map((snapshot) =>
      snapshot.docs.map((d) => HealthEvent.fromJson(d.data())).toList());
}

@riverpod
Stream<List<Vaccination>> vaccinations(Ref ref, int? cutOff) async* {
  var db = FirebaseFirestore.instance;
  String account = await ref.watch(accountProvider.future);
  var cutoffDays = DateTimeUtils.today().subtract(Duration(days: cutOff ?? 30));
  String path = "accounts/$account/data/kennel/vaccinations";
  var collection = db.collection(path);
  var query = collection.where("createdAt", isGreaterThanOrEqualTo: cutoffDays);
  yield* query.snapshots().map((snapshot) =>
      snapshot.docs.map((d) => Vaccination.fromJson(d.data())).toList());
}

@riverpod
Stream<List<HeatCycle>> heatCycles(Ref ref, int? cutOff) async* {
  var db = FirebaseFirestore.instance;
  String account = await ref.watch(accountProvider.future);
  var cutoffDays = DateTimeUtils.today().subtract(Duration(days: cutOff ?? 30));
  String path = "accounts/$account/data/kennel/heatCycles";
  var collection = db.collection(path);
  var query = collection.where("createdAt", isGreaterThanOrEqualTo: cutoffDays);
  yield* query.snapshots().map((snapshot) =>
      snapshot.docs.map((d) => HeatCycle.fromJson(d.data())).toList());
}

@riverpod
class TriggerAddhealthEvent extends _$TriggerAddhealthEvent {
  @override
  bool build() => false;

  void setValue(bool value) {
    state = value;
  }
}
