import 'package:flutter/material.dart';
import 'package:mush_on/settings/stripe_repository.dart';

class StripeConnectionResultWidget extends StatelessWidget {
  final String? account;
  final String? resultString;
  const StripeConnectionResultWidget(
      {super.key, required this.account, required this.resultString});

  @override
  Widget build(BuildContext context) {
    final result = ResultTypeX.fromString(account);
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
                : StripeConnectionSuccess(account: account!),
      )),
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
        "Error: account or result type is null: $account - $resultType - $resultString");
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
          if (snapshot.hasData) {
            return const Text("Operation failed, Please try again.");
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class StripeConnectionSuccess extends StatelessWidget {
  final String account;
  const StripeConnectionSuccess({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StripeRepository(account: account)
            .changeStripeIntegrationActivation(true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Text("Stripe account connected successfully!");
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

enum ResultType { success, failed, none }

extension ResultTypeX on ResultType {
  static ResultType fromString(String? value) {
    if (value == "success") {
      return ResultType.success;
    }
    if (value == "failed") {
      return ResultType.failed;
    }
    return ResultType.none;
  }
}
