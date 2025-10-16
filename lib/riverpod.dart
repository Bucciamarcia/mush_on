import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'riverpod.g.dart';

@Riverpod(keepAlive: true)
Stream<User?> user(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}

/// Helper function to get Firestore document with exponential backoff retry
/// Handles race conditions where auth token hasn't propagated yet
Future<DocumentSnapshot<Map<String, dynamic>>> _getDocumentWithRetry(
  DocumentReference<Map<String, dynamic>> doc, {
  int maxRetries = 4,
  Duration initialDelay = const Duration(milliseconds: 300),
}) async {
  int attempt = 0;
  while (true) {
    try {
      return await doc.get();
    } catch (e) {
      if (e.toString().contains('permission-denied') && attempt < maxRetries) {
        // Exponential backoff: 300ms, 600ms, 1200ms, 2400ms
        final delay = initialDelay * (1 << attempt);
        await Future.delayed(delay);
        attempt++;
      } else {
        rethrow;
      }
    }
  }
}

@Riverpod(keepAlive: true)

/// This provider streams a user from firestore. Use UID to determine which, or null for self.
/// If it returns null, it couldn't find it.
Stream<UserName?> userName(Ref ref, String? uid) async* {
  late String path;
  User? currentUser;

  if (uid == null) {
    User? user = ref.watch(userProvider).value;
    if (user == null) {
      yield null;
      return;
    } else {
      currentUser = user;
      path = "users/${user.uid}";

      // Add delay to allow auth token to propagate to Firestore
      // This prevents race conditions on fresh logins
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  } else {
    currentUser = FirebaseAuth.instance.currentUser;
    path = "users/$uid";
  }

  // Force token refresh to ensure Firestore has the latest auth state
  if (currentUser != null) {
    await currentUser.getIdToken(true);
  }

  var doc = FirebaseFirestore.instance.doc(path);

  // First, try to get the document with retry logic
  try {
    final initialSnapshot = await _getDocumentWithRetry(doc);
    if (initialSnapshot.data() != null) {
      yield UserName.fromJson(initialSnapshot.data()!);
    } else {
      yield null;
    }
  } catch (e) {
    // If all retries fail, rethrow
    rethrow;
  }

  // Then listen for subsequent updates (without retry logic)
  await for (var snapshot in doc.snapshots().skip(1)) {
    if (snapshot.data() != null) {
      yield UserName.fromJson(snapshot.data()!);
    } else {
      yield null;
    }
  }
}

@Riverpod(keepAlive: true)
Stream<String> account(Ref ref) async* {
  // Wait for the auth state to produce a valid, non-null user
  UserName? userName = await ref.watch(userNameProvider(null).future);
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
      return const SettingsModel();
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
