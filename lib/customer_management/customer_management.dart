import 'package:flutter/material.dart';
import 'package:mush_on/page_template.dart';

import 'main.dart';

class ClientManagementScreen extends StatelessWidget {
  const ClientManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(
        title: "Manage Clients", child: ClientManagementMainScreen());
  }
}
