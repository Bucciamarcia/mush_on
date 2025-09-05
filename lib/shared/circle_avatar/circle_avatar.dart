import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/riverpod/user.dart';

class CircleAvatarWidget extends ConsumerWidget {
  final String? uid;
  final double radius;
  const CircleAvatarWidget({super.key, required this.radius, this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Uint8List? profilePic;
    profilePic = ref.watch(userProfilePicProvider(uid)).value;
    UserName? userName = ref.watch(userNameProvider(uid)).value;
    String? nameFirstLetter;
    if (userName != null) {
      if (userName.name.isNotEmpty) {
        nameFirstLetter = userName.name[0];
      }
    }

    late Widget noAvatarPlaceholder;
    if (nameFirstLetter != null) {
      noAvatarPlaceholder = Text(
        nameFirstLetter,
        style: TextStyle(
          fontSize: radius * 0.6,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      noAvatarPlaceholder = Icon(Icons.person, size: radius);
    }
    return CircleAvatar(
      radius: radius,
      backgroundImage: profilePic != null ? MemoryImage(profilePic) : null,
      child: profilePic == null ? noAvatarPlaceholder : null,
    );
  }
}
