import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@Riverpod(keepAlive: true)
Future<String> account(Ref ref) async {
  String account = await FirestoreService().getUserAccount();
  return account;
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
  final withExpirationAsync = ref.watch(tasksWithExpirationProvider(days));
  final noExpirationAsync = ref.watch(tasksNoExpirationProvider);

  if (withExpirationAsync.isLoading || noExpirationAsync.isLoading) {}

  if (withExpirationAsync.hasError) {
    throw withExpirationAsync.error!;
  }

  if (noExpirationAsync.hasError) {
    throw noExpirationAsync.error!;
  }

  // 3. Proceed only when both have data.
  if (withExpirationAsync.hasValue && noExpirationAsync.hasValue) {
    final expiredTasks = withExpirationAsync.value!;
    final noExpTasks = noExpirationAsync.value!;

    final combined = [...expiredTasks, ...noExpTasks]
      ..sort((a, b) => a.title.compareTo(b.title));

    yield TasksInMemory(
      tasks: combined,
      oldestFetched: DateTime.now().subtract(Duration(days: days ?? 30)),
      noExpirationFetched: true,
    );
  }
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
