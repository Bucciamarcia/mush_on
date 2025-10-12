import 'package:flutter/material.dart';
import 'package:mush_on/customer_facing/booking_page/repository.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: BookingPageRepository.getFullPrivacyPolicy(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            if (data == null) {
              return const Text("No policy present");
            }
            return Scaffold(
              body: SafeArea(child: SingleChildScrollView(child: Text(data))),
            );
          } else if (snapshot.hasError) {
            return const Text("Error");
          } else {
            return const CircularProgressIndicator.adaptive();
          }
        });
  }
}
