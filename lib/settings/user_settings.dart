import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/shared/text_title.dart';

class UserSettings extends ConsumerWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TextTitle("User settings"),
      ],
    );
  }
}
