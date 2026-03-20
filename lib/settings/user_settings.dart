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
import 'package:mush_on/settings/section_shell.dart';
import 'package:mush_on/shared/circle_avatar/circle_avatar.dart';

class UserSettings extends ConsumerWidget {
  static final logger = BasicLogger();
  final UserNameRepository? userNameRepository;
  const UserSettings({super.key, this.userNameRepository});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsSectionShell(
      title: "User settings",
      description:
          "Update the personal details shown across the workspace without changing account behavior.",
      badge: "Profile",
      child: Column(
        children: [
          SettingsSurface(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 700;

                final avatarColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Profile picture",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Upload a square image for the cleanest result across the app and desktop views.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatarWidget(radius: 50),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton.icon(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                    allowMultiple: false, type: FileType.image);
                            if (result != null) {
                              PlatformFile file = result.files.single;
                              Uint8List? data = file.bytes;

                              if (data == null && file.path != null) {
                                try {
                                  final fileBytes =
                                      await File(file.path!).readAsBytes();
                                  data = fileBytes;
                                  if (data.lengthInBytes >= 10 * 1024 * 1024) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        errorSnackBar(
                                            context, "File is too large"),
                                      );
                                    }
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
                                      .read(
                                          userProfilePicProvider(null).notifier)
                                      .changeProfilePic(data);
                                } catch (e, s) {
                                  logger.error("Error writing avatar",
                                      error: e, stackTrace: s);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      errorSnackBar(context,
                                          "Couldn't change profile picture"),
                                    );
                                  }
                                }
                              }
                            }
                          },
                          icon: const Icon(Icons.upload_outlined),
                          label: const Text("Change profile picture"),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final u = await ref.watch(userProvider.future);
                            String uid = u!.uid;
                            try {
                              await (userNameRepository ?? UserNameRepository())
                                  .deleteAvatar(
                                uid,
                              );
                              ref
                                  .read(userProfilePicProvider(null).notifier)
                                  .removeProfilePic();
                            } catch (e, s) {
                              logger.error("Error deleting avatar",
                                  error: e, stackTrace: s);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar(context,
                                      "Couldn't delete profile picture"),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.delete_outline),
                          label: const Text("Delete profile picture"),
                        ),
                      ],
                    ),
                  ],
                );

                final nameColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your name",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This is the name other users will see in shared parts of the account.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 20),
                    UsernameNameWidget(userNameRepository: userNameRepository),
                  ],
                );

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: avatarColumn),
                      const SizedBox(width: 24),
                      Expanded(child: nameColumn),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    avatarColumn,
                    const SizedBox(height: 28),
                    nameColumn,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UsernameNameWidget extends ConsumerStatefulWidget {
  final UserNameRepository? userNameRepository;
  const UsernameNameWidget({super.key, this.userNameRepository});

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
    username = await ref.read(userNameProvider(null).future);
    controller.text = username?.name ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Name",
            hintText: "Enter your name",
          ),
          controller: controller,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () async {
            final repo = widget.userNameRepository ?? UserNameRepository();
            try {
              if (username == null) {
                return;
              }
              await repo.setUsername(
                username!.copyWith(name: controller.text),
              );
            } catch (e, s) {
              if (context.mounted) {
                UserSettings.logger
                    .error("Error setting username", error: e, stackTrace: s);
                ScaffoldMessenger.of(context).showSnackBar(
                  errorSnackBar(context, "Couldn't change name"),
                );
              }
            }
          },
          child: const Text("Change name"),
        ),
      ],
    );
  }
}
