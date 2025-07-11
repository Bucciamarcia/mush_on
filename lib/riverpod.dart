import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'riverpod.g.dart';

@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}

@Riverpod(keepAlive: true)

/// This provider streams the current user from Firestore.
/// If it returns null, the user is not logged in.
Stream<UserName?> userName(Ref ref) async* {
  User? user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    yield null;
  } else {
    final path = "users/${user.uid}";
    BasicLogger().info("path: $path");
    var doc = FirebaseFirestore.instance.doc(path);
    yield* doc.snapshots().map(
      (snapshot) {
        if (snapshot.data() != null) {
          return UserName.fromJson(snapshot.data()!);
        } else {
          return null;
        }
      },
    );
  }
}

@Riverpod(keepAlive: true)
Stream<String> account(Ref ref) async* {
  // Wait for the auth state to produce a valid, non-null user
  UserName? userName = await ref.watch(userNameProvider.future);
  yield userName?.account ?? "";
}

@Riverpod(keepAlive: true)
Stream<SettingsModel> settings(Ref ref) async* {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/settings";
  var doc = FirebaseFirestore.instance.doc(path);
  yield* doc.snapshots().map((snapshot) {
    if (snapshot.data() != null) {
      return SettingsModel.fromJson(snapshot.data()!);
    } else {
      return SettingsModel();
    }
  });
}

@Riverpod(keepAlive: true)
Stream<List<Task>> tasksWithExpiration(Ref ref, int? days) async* {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/misc/tasks";
  var collection = FirebaseFirestore.instance.collection(path);
  yield* collection
      .where("expiration",
          isGreaterThanOrEqualTo:
              DateTime.now().subtract(Duration(days: days ?? 30)))
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((t) => Task.fromJson(t.data())).toList());
}

@Riverpod(keepAlive: true)
Stream<List<Task>> tasksNoExpiration(Ref ref) async* {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/misc/tasks";
  var collection = FirebaseFirestore.instance.collection(path);
  yield* collection.where("expiration", isNull: true).snapshots().map(
      (snapshot) => snapshot.docs.map((t) => Task.fromJson(t.data())).toList());
}

@Riverpod(keepAlive: true)
Stream<TasksInMemory> tasks(Ref ref, int? days) async* {
  final account = await ref.watch(accountProvider.future);
  final path = "accounts/$account/data/misc/tasks";
  final collection = FirebaseFirestore.instance.collection(path);

  // Query 1: Tasks with an expiration date
  final expirationStream = collection
      .where(
        "expiration",
        isGreaterThanOrEqualTo:
            DateTime.now().subtract(Duration(days: days ?? 30)),
      )
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((t) => Task.fromJson(t.data())).toList());

  // Query 2: Tasks with no expiration date
  final noExpirationStream = collection
      .where("expiration", isNull: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((t) => Task.fromJson(t.data())).toList());

  // Combine the latest results from both streams
  yield* Rx.combineLatest2(
    expirationStream,
    noExpirationStream,
    (List<Task> withExp, List<Task> noExp) {
      final combined = [...withExp, ...noExp]
        ..sort((a, b) => a.title.compareTo(b.title));

      return TasksInMemory(
        tasks: combined,
        oldestFetched: DateTime.now().subtract(Duration(days: days ?? 30)),
        noExpirationFetched: true,
      );
    },
  );
}

@Riverpod(keepAlive: true)
Stream<List<Dog>> dogs(Ref ref) async* {
  var db = FirebaseFirestore.instance;
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/kennel/dogs";
  var query = db.collection(path).orderBy("name");
  yield* query.snapshots().map(
      (snapshot) => snapshot.docs.map((d) => Dog.fromJson(d.data())).toList());
}
