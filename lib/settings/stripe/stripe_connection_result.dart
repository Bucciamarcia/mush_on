import 'package:flutter/material.dart';

import 'stripe_repository.dart';

class StripeConnectionResultWidget extends StatelessWidget {
  final String? account;
  final String? resultString;
  const StripeConnectionResultWidget(
      {super.key, required this.account, required this.resultString});

  @override
  Widget build(BuildContext context) {
    final result = ResultTypeX.fromString(resultString);
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: (result == ResultType.none || account == null)
                  ? Column(
                      children: [
                        Text(resultString ?? "none"),
                        StripeConnectionError(
                          account: account,
                          resultType: result,
                          resultString: resultString,
                        ),
                      ],
                    )
                  : (result == ResultType.failed)
                      ? StripeConnectionFailed(account: account!)
                      : const SizedBox.shrink())),
    );
  }
}

class StripeConnectionError extends StatelessWidget {
  final String? account;
  final ResultType resultType;
  final String? resultString;
  const StripeConnectionError(
      {super.key,
      required this.account,
      required this.resultType,
      required this.resultString});

  @override
  Widget build(BuildContext context) {
    return Text(
        "Error 2: account or result type is null: $account - $resultType - $resultString");
  }
}

class StripeConnectionFailed extends StatelessWidget {
  final String account;
  const StripeConnectionFailed({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StripeRepository(account: account).removeStripeAccountId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return const Text("Operation failed, Please try again.");
          }
        });
  }
}

enum ResultType { success, failed, none }

extension ResultTypeX on ResultType {
  static ResultType fromString(String? value) {
    final normalized = value?.trim().toLowerCase();
    if (normalized == "success") {
      return ResultType.success;
    }
    if (normalized == "failed") {
      return ResultType.failed;
    }
    return ResultType.none;
  }
}
