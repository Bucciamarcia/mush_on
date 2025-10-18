import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/models/user_level.dart';

class SettingsRepository {
  final db = FirebaseFirestore.instance;
  final String account;
  static BasicLogger logger = BasicLogger();

  SettingsRepository({required this.account});

  Future<void> addCustomField(
      CustomFieldTemplate cf, SettingsModel currentSettings) async {
    var newSettings = currentSettings.copyWith(
        customFieldTemplates: [...currentSettings.customFieldTemplates, cf]);
    String path = "accounts/$account/data/settings";
    var doc = db.doc(path);
    try {
      await doc.set(newSettings.toJson());
    } catch (e, s) {
      logger.error("Couldn't add custom field to db", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteCustomField(
      String id, SettingsModel currentSettings) async {
    List<CustomFieldTemplate> templates =
        List.from(currentSettings.customFieldTemplates);
    templates.removeWhere((t) => t.id == id);
    SettingsModel newSettings =
        currentSettings.copyWith(customFieldTemplates: templates);
    String path = "accounts/$account/data/settings";
    var doc = db.doc(path);
    try {
      await doc.set(newSettings.toJson());
    } catch (e, s) {
      logger.error("Couldn't delete custom field from db",
          error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> addDistanceWarning(
      DistanceWarning warning, SettingsModel currentSettings) async {
    List<DistanceWarning> warnings =
        List.from(currentSettings.globalDistanceWarnings);
    warnings.add(warning);
    SettingsModel newSettings =
        currentSettings.copyWith(globalDistanceWarnings: warnings);
    String path = "accounts/$account/data/settings";
    var doc = db.doc(path);
    try {
      await doc.set(newSettings.toJson());
    } catch (e, s) {
      logger.error("Couldn't add distance warning", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> editDistanceWarning(
      DistanceWarning warning, SettingsModel currentSettings) async {
    List<DistanceWarning> warnings =
        List.from(currentSettings.globalDistanceWarnings);
    warnings.removeWhere((w) => w.id == warning.id);
    warnings.add(warning);
    SettingsModel newSettings =
        currentSettings.copyWith(globalDistanceWarnings: warnings);
    String path = "accounts/$account/data/settings";
    var doc = db.doc(path);
    try {
      await doc.set(newSettings.toJson());
    } catch (e, s) {
      logger.error("Couldn't add distance warning", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> removeDistanceWarning(
      String id, SettingsModel currentSettings) async {
    List<DistanceWarning> warnings =
        List.from(currentSettings.globalDistanceWarnings);
    warnings.removeWhere((w) => w.id == id);
    SettingsModel newSettings =
        currentSettings.copyWith(globalDistanceWarnings: warnings);
    String path = "accounts/$account/data/settings";
    var doc = db.doc(path);
    try {
      await doc.set(newSettings.toJson());
    } catch (e, s) {
      logger.error("Couldn't add distance warning", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> addUser(
      {required String email, required UserLevel userLevel}) async {}
}
