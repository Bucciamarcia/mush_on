import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/services/models/settings/settings.dart';

class SettingsProvider extends ChangeNotifier {
  MainProvider mainProvider;
  BasicLogger logger = BasicLogger();
  late SettingsModel settings = SettingsModel();
  bool didSomethingChange = false;
  bool _isInitLoading = true;
  bool get isInitLoading => _isInitLoading;

  SettingsProvider(this.mainProvider) {
    _getSettings();
  }

  void changeDidSomethingChange(bool b) {
    didSomethingChange = b;
    notifyListeners();
  }

  Future<void> addWarning(DistanceWarning warning) async {
    try {
      FirestoreService firestore = FirestoreService();
      String account = mainProvider.account;
      if (account.isEmpty) {
        account = await FirestoreService().getUserAccount();
      }
      String path = "accounts/$account/data/settings";
      SettingsModel newSettings = settings.copyWith(
        globalDistanceWarnings: [...settings.globalDistanceWarnings, warning],
      );
      var payload = newSettings.toJson();
      await firestore.addDocToDb(payload: payload, path: path, merge: true);
      settings = newSettings;
      notifyListeners();
    } catch (e, s) {
      logger.error("Couldn't add warning", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> editWarning(DistanceWarning warning) async {
    try {
      FirestoreService firestore = FirestoreService();
      String account = mainProvider.account;
      if (account.isEmpty) {
        account = await FirestoreService().getUserAccount();
      }
      String path = "accounts/$account/data/settings";
      List<DistanceWarning> newWarnings =
          List<DistanceWarning>.from(settings.globalDistanceWarnings);
      newWarnings.removeWhere((w) => w.id == warning.id);
      newWarnings.add(warning);
      SettingsModel newSettings =
          settings.copyWith(globalDistanceWarnings: newWarnings);
      var payload = newSettings.toJson();
      await firestore.addDocToDb(payload: payload, path: path, merge: true);
      settings = newSettings;
      notifyListeners();
    } catch (e, s) {
      logger.error("Couldn't remove warning", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> removeWarning(String id) async {
    try {
      FirestoreService firestore = FirestoreService();
      String account = mainProvider.account;
      if (account.isEmpty) {
        account = await FirestoreService().getUserAccount();
      }
      String path = "accounts/$account/data/settings";
      List<DistanceWarning> newWarnings =
          List<DistanceWarning>.from(settings.globalDistanceWarnings);
      newWarnings.removeWhere((w) => w.id == id);
      SettingsModel newSettings =
          settings.copyWith(globalDistanceWarnings: newWarnings);
      var payload = newSettings.toJson();
      await firestore.addDocToDb(payload: payload, path: path, merge: true);
      settings = newSettings;
      notifyListeners();
    } catch (e, s) {
      logger.error("Couldn't remove warning", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> _getSettings() async {
    String account = mainProvider.account;
    if (account.isEmpty) {
      account = await FirestoreService().getUserAccount();
    }
    String path = "accounts/$account/data/settings";

    try {
      var db = FirebaseFirestore.instance;
      var docRef = db.doc(path);

      docRef.snapshots().listen(
        (snapshot) {
          var data = snapshot.data();
          if (data != null) {
            settings = SettingsModel.fromJson(data);
          } else {
            settings = SettingsModel();
          }
          _isInitLoading = false;
          notifyListeners();
        },
        onError: (e, s) {
          logger.error("Couldn't get settings", error: e, stackTrace: s);
          settings = SettingsModel();
          _isInitLoading = false;
          notifyListeners();
        },
      );
    } catch (e, s) {
      // This will only catch errors in setting up the listener
      logger.error("Couldn't set up settings listener",
          error: e, stackTrace: s);
      settings = SettingsModel();
      _isInitLoading = false;
      notifyListeners();
    }
  }

  void addCustomField(CustomFieldTemplate newField) {
    List<CustomFieldTemplate> updatedList =
        List<CustomFieldTemplate>.from(settings.customFieldTemplates)
          ..add(newField);
    settings = settings.copyWith(customFieldTemplates: updatedList);
    didSomethingChange = true;
    notifyListeners();
  }

  void deleteCustomField(String toRemove) {
    List<CustomFieldTemplate> updatedList =
        List<CustomFieldTemplate>.from(settings.customFieldTemplates);
    updatedList.removeWhere((i) => i.id == toRemove);
    settings = settings.copyWith(customFieldTemplates: updatedList);
    didSomethingChange = true;
    notifyListeners();
  }

  Future<void> saveSettingsToDb() async {
    Map<String, dynamic> payload = settings.toJson();
    String account = mainProvider.account;
    if (account.isEmpty) {
      account = await FirestoreService().getUserAccount();
    }
    String path = "accounts/$account/data/settings";
    try {
      await FirestoreService()
          .addDocToDb(payload: payload, path: path, merge: false);
    } catch (e, s) {
      logger.error(
          "Couldn't save settings to db. Path: $path\n\nPayload: $payload",
          error: e,
          stackTrace: s);
      rethrow;
    }
  }
}
