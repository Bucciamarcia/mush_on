import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/settings/user_settings.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(
      title: "My Profile",
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: const UserSettings(),
          ),
        ),
      ),
    );
  }
}
