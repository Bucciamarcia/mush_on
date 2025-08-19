import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerFacingPage extends ConsumerWidget {
  final String account;
  final String cgId;
  const CustomerFacingPage(
      {super.key, required this.account, required this.cgId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: SafeArea(
        child: Placeholder(),
      ),
    );
  }
}
