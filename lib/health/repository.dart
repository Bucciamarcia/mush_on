import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/firestore.dart';

/// Db interaction for all health related stuff
class HealthRepository {
  final _db = FirebaseFirestore.instance;

  /// Returns a list of health events. Defaults to 30 days cutoff and all dogs.
  Stream<List<HealthEvent>> watchHealthEvents(
      {DateTime? cutOff, String? dogId, String? account}) async* {
    account ??= await FirestoreService().getUserAccount();
    cutOff ??= DateTimeUtils.today().subtract(Duration(days: 30));
    String path = "accounts/$account/data/kennel/healthEvents";
    var collectionRef = _db.collection(path);
    var query =
        collectionRef.where("createdAt", isGreaterThanOrEqualTo: cutOff);
    if (dogId != null) {
      query = query.where("dogId", isEqualTo: dogId);
    }
    yield* query.snapshots().map((snapshot) =>
        snapshot.docs.map((d) => HealthEvent.fromJson(d.data())).toList());
  }

  Stream<List<Vaccination>> watchVaccinationEvents(
      {DateTime? cutOff, String? dogId, String? account}) async* {
    account ??= await FirestoreService().getUserAccount();
    cutOff ??= DateTimeUtils.today().subtract(Duration(days: 30));
    String path = "accounts/$account/data/kennel/vaccinations";
    var collectionRef = _db.collection(path);
    var query =
        collectionRef.where("createdAt", isGreaterThanOrEqualTo: cutOff);
    if (dogId != null) {
      query = query.where("dogId", isEqualTo: dogId);
    }
    yield* query.snapshots().map((snapshot) =>
        snapshot.docs.map((d) => Vaccination.fromJson(d.data())).toList());
  }

  Stream<List<HeatCycle>> watchHeatEvents(
      {DateTime? cutOff, String? dogId, String? account}) async* {
    account ??= await FirestoreService().getUserAccount();
    cutOff ??= DateTimeUtils.today().subtract(Duration(days: 30));
    String path = "accounts/$account/data/kennel/heatCycles";
    var collectionRef = _db.collection(path);
    var query =
        collectionRef.where("createdAt", isGreaterThanOrEqualTo: cutOff);
    if (dogId != null) {
      query = query.where("dogId", isEqualTo: dogId);
    }
    yield* query.snapshots().map((snapshot) =>
        snapshot.docs.map((d) => HeatCycle.fromJson(d.data())).toList());
  }
}
