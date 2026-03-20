import 'package:cloud_functions/cloud_functions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'package:mush_on/services/models/username.dart';
import 'package:mush_on/settings/repository.dart';

class _FakeFirebaseFunctions implements FirebaseFunctions {
  String? calledName;
  final _FakeHttpsCallable callable = _FakeHttpsCallable();

  @override
  HttpsCallable httpsCallable(String name, {HttpsCallableOptions? options}) {
    calledName = name;
    return callable;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpsCallable implements HttpsCallable {
  Map<String, dynamic>? lastPayload;
  Object? exception;

  @override
  Future<HttpsCallableResult<T>> call<T>([dynamic parameters]) async {
    if (exception != null) {
      throw exception!;
    }
    lastPayload = Map<String, dynamic>.from(parameters as Map);
    return _FakeHttpsCallableResult<T>();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpsCallableResult<T> implements HttpsCallableResult<T> {
  @override
  T get data => null as dynamic;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('SettingsRepository', () {
    late FakeFirebaseFirestore firestore;
    late SettingsRepository repository;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      final functions = _FakeFirebaseFunctions();
      repository = SettingsRepository(
        account: 'account-1',
        firestore: firestore,
        functions: functions,
      );
    });

    test('addCustomField appends the new template to settings', () async {
      const currentSettings = SettingsModel(
        customFieldTemplates: [
          CustomFieldTemplate(
            id: 'existing',
            name: 'Coat',
            type: CustomFieldType.typeString,
          ),
        ],
      );
      const newTemplate = CustomFieldTemplate(
        id: 'new',
        name: 'Harness size',
        type: CustomFieldType.typeDropdown,
        options: ['S', 'M'],
      );

      await repository.addCustomField(newTemplate, currentSettings);

      final snapshot =
          await firestore.doc('accounts/account-1/data/settings').get();
      final savedSettings = SettingsModel.fromJson(snapshot.data()!);

      expect(savedSettings.customFieldTemplates, [
        currentSettings.customFieldTemplates.first,
        newTemplate,
      ]);
    });

    test('deleteCustomField removes only the matching template', () async {
      const currentSettings = SettingsModel(
        customFieldTemplates: [
          CustomFieldTemplate(
            id: 'remove-me',
            name: 'Favorite trail',
            type: CustomFieldType.typeString,
          ),
          CustomFieldTemplate(
            id: 'keep-me',
            name: 'Boot size',
            type: CustomFieldType.typeInt,
          ),
        ],
      );

      await repository.deleteCustomField('remove-me', currentSettings);

      final snapshot =
          await firestore.doc('accounts/account-1/data/settings').get();
      final savedSettings = SettingsModel.fromJson(snapshot.data()!);

      expect(savedSettings.customFieldTemplates, [
        currentSettings.customFieldTemplates.last,
      ]);
    });

    test('addDistanceWarning appends a warning', () async {
      const currentSettings = SettingsModel(
        globalDistanceWarnings: [
          DistanceWarning(id: 'soft-1', distance: 120, daysInterval: 7),
        ],
      );
      const newWarning = DistanceWarning(
        id: 'hard-1',
        distance: 200,
        daysInterval: 14,
        distanceWarningType: DistanceWarningType.hard,
      );

      await repository.addDistanceWarning(newWarning, currentSettings);

      final snapshot =
          await firestore.doc('accounts/account-1/data/settings').get();
      final savedSettings = SettingsModel.fromJson(snapshot.data()!);

      expect(savedSettings.globalDistanceWarnings, [
        currentSettings.globalDistanceWarnings.first,
        newWarning,
      ]);
    });

    test('editDistanceWarning replaces the matching warning', () async {
      const currentSettings = SettingsModel(
        globalDistanceWarnings: [
          DistanceWarning(id: 'warning-1', distance: 100, daysInterval: 5),
          DistanceWarning(id: 'warning-2', distance: 180, daysInterval: 12),
        ],
      );
      const editedWarning = DistanceWarning(
        id: 'warning-1',
        distance: 140,
        daysInterval: 10,
        distanceWarningType: DistanceWarningType.hard,
      );

      await repository.editDistanceWarning(editedWarning, currentSettings);

      final snapshot =
          await firestore.doc('accounts/account-1/data/settings').get();
      final savedSettings = SettingsModel.fromJson(snapshot.data()!);

      expect(savedSettings.globalDistanceWarnings, contains(editedWarning));
      expect(
        savedSettings.globalDistanceWarnings.where((w) => w.id == 'warning-1'),
        [editedWarning],
      );
      expect(savedSettings.globalDistanceWarnings, hasLength(2));
    });

    test('removeDistanceWarning deletes the matching warning', () async {
      const currentSettings = SettingsModel(
        globalDistanceWarnings: [
          DistanceWarning(id: 'warning-1', distance: 100, daysInterval: 5),
          DistanceWarning(id: 'warning-2', distance: 180, daysInterval: 12),
        ],
      );

      await repository.removeDistanceWarning('warning-1', currentSettings);

      final snapshot =
          await firestore.doc('accounts/account-1/data/settings').get();
      final savedSettings = SettingsModel.fromJson(snapshot.data()!);

      expect(savedSettings.globalDistanceWarnings, [
        currentSettings.globalDistanceWarnings.last,
      ]);
    });

    test('addUser calls invite_user with the expected payload', () async {
      final functions = _FakeFirebaseFunctions();
      final repository = SettingsRepository(
        account: 'account-1',
        firestore: firestore,
        functions: functions,
      );
      const sender = UserName(
        uid: 'sender-1',
        email: 'sender@example.com',
        account: 'account-1',
        userLevel: UserLevel.musher,
      );

      await repository.addUser(
        email: 'new.user@example.com',
        userLevel: UserLevel.musher,
        senderUser: sender,
      );

      final captured = functions.callable.lastPayload!;

      expect(functions.calledName, 'invite_user');
      expect(captured['senderEmail'], sender.email);
      expect(captured['receiverEmail'], 'new.user@example.com');
      expect(captured['account'], 'account-1');
      expect(captured['payload']['email'], 'new.user@example.com');
      expect(captured['payload']['account'], 'account-1');
      expect(captured['payload']['senderUid'], sender.uid);
      expect(captured['payload']['accepted'], false);
      expect(captured['payload']['userLevel'], 'musher');
      expect(captured['payload']['securityCode'], isNotEmpty);
    });

    test('addUser rethrows cloud function failures', () async {
      final functions = _FakeFirebaseFunctions();
      final repository = SettingsRepository(
        account: 'account-1',
        firestore: firestore,
        functions: functions,
      );

      functions.callable.exception = Exception('boom');

      expect(
        () => repository.addUser(
          email: 'new.user@example.com',
          userLevel: UserLevel.handler,
          senderUser: const UserName(
            uid: 'sender-1',
            email: 'sender@example.com',
          ),
        ),
        throwsException,
      );
    });
  });
}
