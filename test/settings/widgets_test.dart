import 'dart:typed_data';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'package:mush_on/services/models/username.dart';
import 'package:mush_on/services/riverpod/user.dart';
import 'package:mush_on/services/storage/username.dart';
import 'package:mush_on/settings/add_users.dart';
import 'package:mush_on/settings/custom_fields.dart';
import 'package:mush_on/settings/main.dart';
import 'package:mush_on/settings/repository.dart';
import 'package:mush_on/settings/stripe/riverpod.dart';
import 'package:mush_on/settings/user_settings.dart';

class _FakeUser implements User {
  @override
  final String uid;

  _FakeUser(this.uid);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RecordingSettingsRepository extends SettingsRepository {
  _RecordingSettingsRepository()
      : super(
          account: 'account-1',
          firestore: FakeFirebaseFirestore(),
        );

  String? addedUserEmail;
  UserLevel? addedUserLevel;
  UserName? addedByUser;
  CustomFieldTemplate? addedCustomField;
  String? deletedCustomFieldId;
  DistanceWarning? addedWarning;

  @override
  Future<void> addUser({
    required String email,
    required UserLevel userLevel,
    required UserName senderUser,
  }) async {
    addedUserEmail = email;
    addedUserLevel = userLevel;
    addedByUser = senderUser;
  }

  @override
  Future<void> addCustomField(
    CustomFieldTemplate cf,
    SettingsModel currentSettings,
  ) async {
    addedCustomField = cf;
  }

  @override
  Future<void> deleteCustomField(
    String id,
    SettingsModel currentSettings,
  ) async {
    deletedCustomFieldId = id;
  }

  @override
  Future<void> addDistanceWarning(
    DistanceWarning warning,
    SettingsModel currentSettings,
  ) async {
    addedWarning = warning;
  }
}

class _FakeUserProfilePic extends UserProfilePic {
  @override
  Future<Uint8List?> build(String? uid) async => null;
}

Future<void> _pumpApp(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddTemplateDialog and custom fields', () {
    testWidgets('does not add a template when the name is empty',
        (tester) async {
      CustomFieldTemplate? addedTemplate;

      await _pumpApp(
        tester,
        CustomFieldsOptions(
          customFieldTemplates: const [],
          onCustomFieldAdded: (template) => addedTemplate = template,
          onCustomFieldDeleted: (_) {},
        ),
      );

      await tester.tap(find.text('Add new custom field'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add custom field'));
      await tester.pumpAndSettle();

      expect(addedTemplate, isNull);
    });

    testWidgets('adds a dropdown template only with non-empty options',
        (tester) async {
      CustomFieldTemplate? addedTemplate;

      await _pumpApp(
        tester,
        CustomFieldsOptions(
          customFieldTemplates: const [],
          onCustomFieldAdded: (template) => addedTemplate = template,
          onCustomFieldDeleted: (_) {},
        ),
      );

      await tester.tap(find.text('Add new custom field'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'Boot size');
      await tester.tap(find.text('Text'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dropdown').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Small');
      await tester.tap(find.text('Add custom field'));
      await tester.pumpAndSettle();

      expect(addedTemplate, isNotNull);
      expect(addedTemplate!.name, 'Boot size');
      expect(addedTemplate!.type, CustomFieldType.typeDropdown);
      expect(addedTemplate!.options, ['Small']);
    });

    testWidgets('deleting a chip forwards the template id', (tester) async {
      String? deletedId;

      await _pumpApp(
        tester,
        CustomFieldsOptions(
          customFieldTemplates: const [
            CustomFieldTemplate(
              id: 'template-1',
              name: 'Coat',
              type: CustomFieldType.typeString,
            ),
          ],
          onCustomFieldAdded: (_) {},
          onCustomFieldDeleted: (id) => deletedId = id,
        ),
      );

      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();

      expect(deletedId, 'template-1');
    });
  });

  group('AddUsers', () {
    late _FakeUser user;
    const sender = UserName(
      uid: 'user-1',
      email: 'sender@example.com',
      account: 'account-1',
      userLevel: UserLevel.musher,
    );

    setUp(() {
      user = _FakeUser('user-1');
    });

    testWidgets('shows guard text when the sender email is empty',
        (tester) async {
      await _pumpApp(
        tester,
        const AddUsers(account: 'account-1'),
        overrides: [
          userProvider.overrideWith((_) => Stream.value(user)),
          userNameProvider('user-1').overrideWith(
            (_) => Stream.value(const UserName(uid: 'user-1', email: '')),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Your email is empty. You must add a valid email on your profile first.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('pressing Add user forwards email and selected level',
        (tester) async {
      final repository = _RecordingSettingsRepository();

      await _pumpApp(
        tester,
        AddUsers(account: 'account-1', repository: repository),
        overrides: [
          userProvider.overrideWith((_) => Stream.value(user)),
          userNameProvider('user-1').overrideWith(
            (_) => Stream.value(sender),
          ),
        ],
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Email address',
        ),
        'new.user@example.com',
      );
      await tester.tap(find.byType(DropdownMenu<UserLevel>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('musher').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add user'));
      await tester.pumpAndSettle();

      expect(repository.addedUserEmail, 'new.user@example.com');
      expect(repository.addedUserLevel, UserLevel.musher);
      expect(repository.addedByUser, sender);
    });
  });

  group('UsernameNameWidget', () {
    testWidgets('loads the current name and persists changes to firestore',
        (tester) async {
      final firestore = FakeFirebaseFirestore();
      final repository = UserNameRepository(firestore: firestore);
      const username = UserName(
        uid: 'user-1',
        email: 'sender@example.com',
        account: 'account-1',
        name: 'Old name',
      );

      await _pumpApp(
        tester,
        UsernameNameWidget(userNameRepository: repository),
        overrides: [
          userNameProvider(null).overrideWith(
            (_) => Stream.value(username),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Old name',
      );

      await tester.enterText(find.byType(TextField), 'New name');
      await tester.tap(find.text('Change name'));
      await tester.pumpAndSettle();

      final snapshot = await firestore.doc('users/user-1').get();
      expect(UserName.fromJson(snapshot.data()!).name, 'New name');
    });
  });

  group('SettingsMain', () {
    late _FakeUser user;
    const baseSettings = SettingsModel(
      customFieldTemplates: [
        CustomFieldTemplate(
          id: 'template-1',
          name: 'Coat',
          type: CustomFieldType.typeString,
        ),
      ],
    );

    setUp(() {
      user = _FakeUser('user-1');
    });

    testWidgets('hides admin-only sections for handlers', (tester) async {
      await _pumpApp(
        tester,
        const SettingsMain(),
        overrides: [
          userProvider.overrideWith((_) => Stream.value(user)),
          userNameProvider('user-1').overrideWith(
            (_) => Stream.value(
              const UserName(
                uid: 'user-1',
                email: 'handler@example.com',
                account: 'account-1',
                userLevel: UserLevel.handler,
              ),
            ),
          ),
          userNameProvider(null).overrideWith(
            (_) => Stream.value(
              UserName(
                uid: 'user-1',
                email: 'handler@example.com',
                account: 'account-1',
                userLevel: UserLevel.handler,
              ),
            ),
          ),
          userProfilePicProvider(null)
              .overrideWith(() => _FakeUserProfilePic()),
          accountProvider.overrideWith((_) => Stream.value('account-1')),
          settingsProvider.overrideWith((_) => Stream.value(baseSettings)),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Add new user'), findsNothing);
      expect(find.text('Connect Stripe'), findsNothing);
      expect(find.text('User settings'), findsOneWidget);
    });

    testWidgets('shows admin-only sections for mushers', (tester) async {
      await _pumpApp(
        tester,
        const SettingsMain(),
        overrides: [
          userProvider.overrideWith((_) => Stream.value(user)),
          userNameProvider('user-1').overrideWith(
            (_) => Stream.value(
              const UserName(
                uid: 'user-1',
                email: 'musher@example.com',
                account: 'account-1',
                userLevel: UserLevel.musher,
              ),
            ),
          ),
          userNameProvider(null).overrideWith(
            (_) => Stream.value(
              UserName(
                uid: 'user-1',
                email: 'musher@example.com',
                account: 'account-1',
                userLevel: UserLevel.musher,
              ),
            ),
          ),
          userProfilePicProvider(null)
              .overrideWith(() => _FakeUserProfilePic()),
          accountProvider.overrideWith((_) => Stream.value('account-1')),
          settingsProvider.overrideWith((_) => Stream.value(baseSettings)),
          stripeConnectionProvider.overrideWith((_) => Stream.value(null)),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Add new user'), findsOneWidget);
      expect(find.text('Connect Stripe'), findsOneWidget);
    });

    testWidgets('uses the repository callbacks for custom fields',
        (tester) async {
      final repository = _RecordingSettingsRepository();

      await _pumpApp(
        tester,
        SettingsMain(repositoryBuilder: (_) => repository),
        overrides: [
          userProvider.overrideWith((_) => Stream.value(user)),
          userNameProvider('user-1').overrideWith(
            (_) => Stream.value(
              const UserName(
                uid: 'user-1',
                email: 'musher@example.com',
                account: 'account-1',
                userLevel: UserLevel.handler,
              ),
            ),
          ),
          userNameProvider(null).overrideWith(
            (_) => Stream.value(
              UserName(
                uid: 'user-1',
                email: 'musher@example.com',
                account: 'account-1',
                userLevel: UserLevel.handler,
              ),
            ),
          ),
          userProfilePicProvider(null)
              .overrideWith(() => _FakeUserProfilePic()),
          accountProvider.overrideWith((_) => Stream.value('account-1')),
          settingsProvider.overrideWith((_) => Stream.value(baseSettings)),
        ],
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add new custom field'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Harness');
      await tester.tap(find.text('Add custom field'));
      await tester.pumpAndSettle();

      expect(repository.addedCustomField, isNotNull);
      expect(repository.addedCustomField!.name, 'Harness');

      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();

      expect(repository.deletedCustomFieldId, 'template-1');
    });

    testWidgets('uses the repository callback for distance warnings',
        (tester) async {
      final repository = _RecordingSettingsRepository();

      await _pumpApp(
        tester,
        SettingsMain(repositoryBuilder: (_) => repository),
        overrides: [
          userProvider.overrideWith((_) => Stream.value(user)),
          userNameProvider('user-1').overrideWith(
            (_) => Stream.value(
              const UserName(
                uid: 'user-1',
                email: 'handler@example.com',
                account: 'account-1',
                userLevel: UserLevel.handler,
              ),
            ),
          ),
          userNameProvider(null).overrideWith(
            (_) => Stream.value(
              UserName(
                uid: 'user-1',
                email: 'handler@example.com',
                account: 'account-1',
                userLevel: UserLevel.handler,
              ),
            ),
          ),
          userProfilePicProvider(null)
              .overrideWith(() => _FakeUserProfilePic()),
          accountProvider.overrideWith((_) => Stream.value('account-1')),
          settingsProvider.overrideWith((_) => Stream.value(baseSettings)),
        ],
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add new warning'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Maximum distance',
        ),
        '150',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Time period',
        ),
        '7',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Add Warning'));
      await tester.pumpAndSettle();

      expect(repository.addedWarning, isNotNull);
      expect(repository.addedWarning!.distance, 150);
      expect(repository.addedWarning!.daysInterval, 7);
      expect(
        repository.addedWarning!.distanceWarningType,
        DistanceWarningType.soft,
      );
    });
  });
}
