import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/username.dart';
import 'package:mush_on/services/riverpod/user.dart';
import 'package:mush_on/services/storage/username.dart';
import 'package:mush_on/shared/circle_avatar/circle_avatar.dart';
import 'package:mush_on/shared/text_title.dart';

class UserSettings extends ConsumerWidget {
  static final logger = BasicLogger();
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TextTitle("User settings"),
        TextTitle("Profile picture"),
        CircleAvatarWidget(radius: 50),
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform
                .pickFiles(allowMultiple: false, type: FileType.image);
            if (result != null) {
              PlatformFile file = result.files.single;
              Uint8List? data = file.bytes;

              // If bytes are null, try to read from path (for mobile platforms)
              if (data == null && file.path != null) {
                try {
                  final fileBytes = await File(file.path!).readAsBytes();
                  data = fileBytes;
                  // If equal or bigger than 10mb, can't upload
                  if (data.lengthInBytes >= 10 * 1024 * 1024) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar(context, "File is too large"),
                    );
                    return;
                  }
                } catch (e) {
                  logger.error("Failed to read file bytes: $e");
                }
              }

              String? extension = file.extension;
              if (data != null && extension != null) {
                String fileName = "avatar.$extension";
                final u = await ref.watch(userProvider.future);
                String uid = u!.uid;
                try {
                  await UserNameRepository().writeAvatar(
                    data,
                    fileName,
                    uid,
                  );
                  ref
                      .read(userProfilePicProvider(null).notifier)
                      .changeProfilePic(data);
                } catch (e, s) {
                  logger.error("Error writing avatar", error: e, stackTrace: s);
                  ScaffoldMessenger.of(context).showSnackBar(
                    errorSnackBar(context, "Couldn't change profile picture"),
                  );
                }
              }
            }
          },
          child: Text("Change profile picture"),
        ),
        ElevatedButton(
          onPressed: () async {
            final u = await ref.watch(userProvider.future);
            String uid = u!.uid;
            try {
              await UserNameRepository().deleteAvatar(uid);
              ref
                  .read(userProfilePicProvider(null).notifier)
                  .removeProfilePic();
            } catch (e, s) {
              logger.error("Error deleting avatar", error: e, stackTrace: s);
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(context, "Couldn't delete profile picture"),
              );
            }
          },
          child: Text("Delete profile picture"),
        ),
        TextTitle("Your name"),
        UsernameNameWidget(),
      ],
    );
  }
}

class UsernameNameWidget extends ConsumerStatefulWidget {
  const UsernameNameWidget({super.key});

  @override
  ConsumerState<UsernameNameWidget> createState() => _UsernameNameWidgetState();
}

class _UsernameNameWidgetState extends ConsumerState<UsernameNameWidget> {
  late TextEditingController controller;
  late UserName? username;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    username = await ref.read(userNameProvider.future);
    controller.text = username?.name ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Name",
            hintText: "Enter your name",
          ),
          controller: controller,
        ),
        ElevatedButton(
          onPressed: () async {
            final repo = UserNameRepository();
            try {
              if (username == null) {
                return;
              }
              await repo.setUsername(
                username!.copyWith(name: controller.text),
              );
            } catch (e, s) {
              UserSettings.logger
                  .error("Error setting username", error: e, stackTrace: s);
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(context, "Couldn't change name"),
              );
            }
          },
          child: Text("Change name"),
        ),
      ],
    );
  }
}
