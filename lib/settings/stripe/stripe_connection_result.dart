import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';

import 'stripe_repository.dart';

class StripeConnectionResultWidget extends StatelessWidget {
  final String? account;
  final String? resultString;
  final String? stripeModeString;
  final String? attemptId;
  final String? token;
  const StripeConnectionResultWidget({
    super.key,
    required this.account,
    required this.resultString,
    required this.stripeModeString,
    required this.attemptId,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final result = ResultTypeX.fromString(resultString);
    final stripeMode = StripeModeX.fromString(stripeModeString);
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
              : (result == ResultType.refresh)
              ? const StripeConnectionRefresh()
              : (result == ResultType.failed)
              ? const StripeConnectionFailed()
              : StripeConnectionSuccess(
                  account: account!,
                  stripeMode: stripeMode,
                  attemptId: attemptId,
                  token: token,
                ),
        ),
      ),
    );
  }
}

class StripeConnectionError extends StatelessWidget {
  final String? account;
  final ResultType resultType;
  final String? resultString;
  const StripeConnectionError({
    super.key,
    required this.account,
    required this.resultType,
    required this.resultString,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Error 2: account or result type is null: $account - $resultType - $resultString",
    );
  }
}

class StripeConnectionFailed extends StatelessWidget {
  const StripeConnectionFailed({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Stripe onboarding was not completed. Please try again from settings.",
    );
  }
}

class StripeConnectionRefresh extends StatelessWidget {
  const StripeConnectionRefresh({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "This Stripe onboarding link expired. Please return to settings and try again.",
    );
  }
}

class StripeConnectionSuccess extends StatefulWidget {
  final String account;
  final StripeMode stripeMode;
  final String? attemptId;
  final String? token;
  const StripeConnectionSuccess({
    super.key,
    required this.account,
    required this.stripeMode,
    required this.attemptId,
    required this.token,
  });

  @override
  State<StripeConnectionSuccess> createState() =>
      _StripeConnectionSuccessState();
}

class _StripeConnectionSuccessState extends State<StripeConnectionSuccess> {
  late final Future<bool> _finalizeFuture;

  @override
  void initState() {
    super.initState();
    _finalizeFuture = _finalizeStripeOnboarding();
  }

  Future<bool> _finalizeStripeOnboarding() {
    final attemptId = widget.attemptId;
    final token = widget.token;
    if (attemptId == null || token == null) {
      return Future.error(
        Exception("Stripe onboarding attempt information is missing"),
      );
    }
    return StripeRepository(
      account: widget.account,
    ).finalizeStripeOnboarding(attemptId: attemptId, token: token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _finalizeFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return const Text("Stripe account connected successfully!");
        } else if (snapshot.hasData) {
          return const Text(
            "Stripe returned successfully, but checkout is not enabled yet. Please continue onboarding from settings.",
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          BasicLogger().error(snapshot.error.toString());
          return Text("Error in stripeconnectionsuccess: ${snapshot.error}");
        }
      },
    );
  }
}

enum ResultType { success, failed, refresh, none }

extension ResultTypeX on ResultType {
  static ResultType fromString(String? value) {
    final normalized = value?.trim().toLowerCase();
    if (normalized == "success") {
      return ResultType.success;
    }
    if (normalized == "failed") {
      return ResultType.failed;
    }
    if (normalized == "refresh") {
      return ResultType.refresh;
    }
    return ResultType.none;
  }
}

extension StripeModeX on StripeMode {
  static StripeMode fromString(String? value) {
    return value?.trim().toLowerCase() == "live"
        ? StripeMode.live
        : StripeMode.test;
  }
}
