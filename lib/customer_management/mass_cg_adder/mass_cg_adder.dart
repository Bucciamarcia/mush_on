import 'package:flutter/material.dart';
import 'package:mush_on/customer_management/mass_cg_adder/main.dart';
import 'package:mush_on/page_template.dart';

class MassCgAdderScreen extends StatelessWidget {
  const MassCgAdderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateScreen(
        title: "Mass add Customer groups", child: MassAddCg());
  }
}
