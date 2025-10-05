import 'package:flutter/material.dart';

class BookingSuccessPage extends StatelessWidget {
  final String? bookingId;
  final String? account;
  const BookingSuccessPage(
      {super.key, required this.bookingId, required this.account});

  @override
  Widget build(BuildContext context) {
    if (bookingId == null || account == null) {
      return const Scaffold(body: SafeArea(child: Text("Error")));
    }
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Text(bookingId!),
              Text(account!),
            ],
          ),
        ),
      ),
    );
  }
}
