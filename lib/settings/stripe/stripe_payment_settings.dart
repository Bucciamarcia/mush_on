import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/section_shell.dart';
import 'package:mush_on/settings/stripe/shopping_cart_settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'riverpod.dart';

class PaymentSettingsWidget extends ConsumerWidget {
  static final logger = BasicLogger();
  const PaymentSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = BasicLogger();
    final account = ref.watch(accountProvider).value;
    if (account == null) {
      logger.error("Account is null");
      return const Text("Error: account not available.");
    } else {
      final stripeConnectionasync = ref.watch(stripeConnectionProvider);
      return stripeConnectionasync.when(
        data: (stripeConnection) {
          if (stripeConnection == null) {
            return SettingsSectionShell(
              title: "Payments",
              description:
                  "Connect Stripe to enable checkout and payment page configuration for your kennel.",
              badge: "Commerce",
              child: SettingsSurface(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConnectStripeButton(account: account),
                ),
              ),
            );
          } else {
            return const ShoppingCartSettings();
          }
        },
        error: (e, s) {
          logger.error(
            "Error loading stripe connection",
            error: e,
            stackTrace: s,
          );
          return Text("Error loading stripe connection: $e");
        },
        loading: () => const CircularProgressIndicator.adaptive(),
      );
    }
  }
}

class ConnectStripeButton extends StatelessWidget {
  final String account;
  const ConnectStripeButton({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final logger = BasicLogger();
    return FilledButton.icon(
      onPressed: () async {
        try {
          final response = await FirebaseFunctions.instanceFor(
            region: "europe-north1",
          ).httpsCallable("stripe_create_account").call({"account": account});
          final responseJson = response.data as Map<String, dynamic>;
          final error = responseJson["error"];
          if (error != null) {
            throw Exception(error);
          }
          final accountId = responseJson["account"];
          if (accountId == null) {
            throw Exception("Account ID is null");
          }
          final responseLink =
              await FirebaseFunctions.instanceFor(region: "europe-north1")
                  .httpsCallable("stripe_create_account_link")
                  .call({"stripeAccount": accountId, "account": account});
          final linkData = responseLink.data as Map<String, dynamic>;
          if (linkData["error"] != null) {
            throw Exception(linkData["error"]);
          }
          final url = linkData["url"];
          if (url == null) {
            throw Exception("URL is null");
          }
          await _launchStripeUrl(url);
        } catch (e, s) {
          logger.error("Couldn't call link", error: e, stackTrace: s);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBar(context, "Couldn't connect Stripe account"),
            );
          }
        }
      },
      icon: const Icon(Icons.account_balance_outlined),
      label: const Text("Connect Stripe"),
    );
  }

  Future<void> _launchStripeUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }
}
