import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'repository.g.dart';

@riverpod
HealthEventRepository healthEventRepository(Ref ref) {
  // Read the current user's account once
  final account = ref.watch(accountProvider);

  // Return an instance of the repository.
  // The 'account' is available as a loading/error/data state.
  return HealthEventRepository(account);
}

class HealthEventRepository {
  var db = FirebaseFirestore.instance;
  static final logger = BasicLogger();
  // It now holds the account state
  final AsyncValue<String> _account;

  // 3. The constructor accepts the account state from the provider
  HealthEventRepository(this._account);

  // 4. Your method is now an instance method, not static
  Future<void> addEvent(HealthEvent event) async {
    // Access the account value safely
    final accountValue = _account.valueOrNull;

    // A robust check to ensure the account is available before proceeding
    if (accountValue == null) {
      logger.error('Could not add event: User account is not available.');
      throw Exception("Could not add event: User account is not available.");
    }

    logger.debug('Adding event for account: $accountValue');
    var payload = event.toJson();
    String path = "accounts/$accountValue/data/kennel/healthEvents";
    var collection = db.collection(path);
    try {
      collection.doc(event.id).set(payload);
    } catch (e, s) {
      logger.error("Couldn't set the new document health event",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}

class VaccinationRepository {
  final AsyncValue<String> _account;
  var db = FirebaseFirestore.instance;
  static final logger = BasicLogger();
  VaccinationRepository(this._account);

  Future<void> addVaccination(Vaccination vaccination) async {
    // Access the account value safely
    final accountValue = _account.valueOrNull;

    // A robust check to ensure the account is available before proceeding
    if (accountValue == null) {
      logger.error('Could not add vaccination: User account is not available.');
      throw Exception(
          "Could not add vaccination: User account is not available.");
    }

    logger.debug('Adding vaccination for account: $accountValue');
    var payload = vaccination.toJson();
    String path = "accounts/$accountValue/data/kennel/vaccinations";
    var collection = db.collection(path);
    try {
      collection.doc(vaccination.id).set(payload);
    } catch (e, s) {
      logger.error("Couldn't set the new document vaccination",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}

@riverpod
VaccinationRepository vaccinationRepository(Ref ref) {
  final account = ref.watch(accountProvider);
  return VaccinationRepository(account);
}
