import 'package:flutter/material.dart';
import 'package:mush_on/resellers/home/main.dart';
import 'package:mush_on/resellers/reseller_template.dart';

class ResellerHome extends StatelessWidget {
  const ResellerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResellerTemplate(
      title: "Reseller portal",
      child: ResellerMain(),
    );
  }
}
