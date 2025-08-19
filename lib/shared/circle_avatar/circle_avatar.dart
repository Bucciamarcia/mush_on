import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/services/riverpod/user.dart';

class CircleAvatarWidget extends ConsumerWidget {
  final String? uid;
  final double radius;
  const CircleAvatarWidget({super.key, required this.radius, this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Uint8List? profilePic;
    profilePic = ref.watch(userProfilePicProvider(uid)).value;
    return CircleAvatar(
      radius: radius,
      backgroundImage: profilePic != null ? MemoryImage(profilePic) : null,
      child: profilePic == null ? Icon(Icons.person, size: radius) : null,
    );
  }
}
