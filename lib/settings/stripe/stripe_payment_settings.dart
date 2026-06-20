import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/section_shell.dart';
import 'package:mush_on/settings/stripe/shopping_cart_settings.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'package:mush_on/settings/stripe/stripe_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'riverpod.dart';

final stripeConnectionStatusProvider =
    FutureProvider.family<StripeConnectionStatus, String>((ref, account) {
      ref.watch(stripeConnectionProvider);
      return StripeRepository(account: account).getStripeConnectionStatus();
    });

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
          final connection = stripeConnection ?? const StripeConnection();
          final activeConnection = _activeModeConnection(connection);
          final hasAccount = activeConnection?.accountId.isNotEmpty == true;
          if (!hasAccount) {
            return StripeConnectionPanel(
              account: account,
              connection: connection,
            );
          }
          final statusAsync = ref.watch(
            stripeConnectionStatusProvider(account),
          );
          return statusAsync.when(
            data: (status) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 18,
              children: [
                StripeConnectionPanel(
                  account: account,
                  connection: connection,
                  status: status,
                ),
                if (status.isReady) const ShoppingCartSettings(),
              ],
            ),
            error: (e, s) {
              logger.error(
                "Error loading stripe status",
                error: e,
                stackTrace: s,
              );
              return StripeConnectionPanel(
                account: account,
                connection: connection,
                statusError: e,
              );
            },
            loading: () => StripeConnectionPanel(
              account: account,
              connection: connection,
              isCheckingStatus: true,
            ),
          );
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

StripeModeConnection? _activeModeConnection(StripeConnection connection) {
  return connection.activeMode == StripeMode.live
      ? connection.live
      : connection.test;
}

String _stripeModeLabel(StripeMode mode) {
  return mode == StripeMode.live ? "Live" : "Test";
}

class StripeConnectionPanel extends StatelessWidget {
  final String account;
  final StripeConnection connection;
  final StripeConnectionStatus? status;
  final Object? statusError;
  final bool isCheckingStatus;
  const StripeConnectionPanel({
    super.key,
    required this.account,
    required this.connection,
    this.status,
    this.statusError,
    this.isCheckingStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    final activeConnection = _activeModeConnection(connection);
    final hasAccount =
        status?.hasAccount ?? activeConnection?.accountId.isNotEmpty == true;
    final isReady = status?.isReady == true;
    final modeLabel = _stripeModeLabel(connection.activeMode);
    final title = isCheckingStatus
        ? "Checking Stripe setup"
        : isReady
        ? "$modeLabel mode ready"
        : hasAccount
        ? "Stripe setup is not complete"
        : "$modeLabel mode not connected";
    final body = statusError != null
        ? "Couldn't refresh Stripe setup status. You can continue setup or disconnect Stripe."
        : isCheckingStatus
        ? "Checking whether this Stripe account can accept payments."
        : isReady
        ? "Checkout can use this Stripe connection while $modeLabel mode is active."
        : hasAccount
        ? status?.reason ??
              "Stripe needs more setup before checkout can be enabled."
        : "Connect Stripe before configuring checkout for $modeLabel mode.";
    final icon = isCheckingStatus
        ? Icons.sync_outlined
        : isReady
        ? Icons.check_circle_outline
        : hasAccount
        ? Icons.warning_amber_outlined
        : Icons.info_outline;
    final iconColor = isReady
        ? Theme.of(context).colorScheme.primary
        : hasAccount
        ? Theme.of(context).colorScheme.tertiary
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return SettingsSectionShell(
      title: "Stripe connection",
      description:
          "Connect Stripe to enable checkout and payment page configuration for your kennel.",
      badge: "Commerce",
      child: SettingsSurface(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          body,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isCheckingStatus)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              )
            else if (isReady)
              DisconnectStripeButton(
                account: account,
                stripeMode: connection.activeMode,
              )
            else if (hasAccount)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ContinueStripeSetupButton(
                    account: account,
                    stripeMode: connection.activeMode,
                  ),
                  DisconnectStripeButton(
                    account: account,
                    stripeMode: connection.activeMode,
                  ),
                ],
              )
            else
              ConnectStripeButton(
                account: account,
                stripeMode: connection.activeMode,
              ),
          ],
        ),
      ),
    );
  }
}

class ConnectStripeButton extends StatefulWidget {
  final String account;
  final StripeMode stripeMode;
  const ConnectStripeButton({
    super.key,
    required this.account,
    this.stripeMode = StripeMode.test,
  });

  @override
  State<ConnectStripeButton> createState() => _ConnectStripeButtonState();
}

class _ConnectStripeButtonState extends State<ConnectStripeButton> {
  bool _isConnecting = false;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: _isConnecting ? null : () => _connectStripe(context),
      icon: _isConnecting
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator.adaptive(strokeWidth: 2),
            )
          : const Icon(Icons.account_balance_outlined),
      label: Text(_isConnecting ? "Connecting..." : "Connect Stripe"),
    );
  }

  Future<void> _connectStripe(BuildContext context) async {
    setState(() => _isConnecting = true);
    try {
      await _runStripeSetupFlow(
        context: context,
        account: widget.account,
        stripeMode: widget.stripeMode,
        createAccount: true,
        loadingMessage: "Creating your payment account with Stripe",
        errorMessage: "Couldn't connect Stripe account",
      );
    } finally {
      if (mounted) setState(() => _isConnecting = false);
    }
  }
}

class ContinueStripeSetupButton extends StatefulWidget {
  final String account;
  final StripeMode stripeMode;
  const ContinueStripeSetupButton({
    super.key,
    required this.account,
    required this.stripeMode,
  });

  @override
  State<ContinueStripeSetupButton> createState() =>
      _ContinueStripeSetupButtonState();
}

class _ContinueStripeSetupButtonState extends State<ContinueStripeSetupButton> {
  bool _isOpening = false;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: _isOpening ? null : () => _continueSetup(context),
      icon: _isOpening
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator.adaptive(strokeWidth: 2),
            )
          : const Icon(Icons.open_in_new_outlined),
      label: Text(_isOpening ? "Opening..." : "Continue setup"),
    );
  }

  Future<void> _continueSetup(BuildContext context) async {
    setState(() => _isOpening = true);
    try {
      await _runStripeSetupFlow(
        context: context,
        account: widget.account,
        stripeMode: widget.stripeMode,
        createAccount: false,
        loadingMessage: "Opening Stripe setup",
        errorMessage: "Couldn't open Stripe setup",
      );
    } finally {
      if (mounted) setState(() => _isOpening = false);
    }
  }
}

Future<void> _runStripeSetupFlow({
  required BuildContext context,
  required String account,
  required StripeMode stripeMode,
  required bool createAccount,
  required String loadingMessage,
  required String errorMessage,
}) async {
  final logger = BasicLogger();
  final navigator = Navigator.of(context, rootNavigator: true);
  final messenger = ScaffoldMessenger.of(context);
  _showStripeSetupOverlay(context, loadingMessage);
  try {
    final repository = StripeRepository(account: account);
    if (createAccount) {
      await repository.createStripeAccount(stripeMode: stripeMode);
    }
    final url = await repository.createStripeAccountLink(
      stripeMode: stripeMode,
    );
    await _launchStripeUrl(url);
  } catch (e, s) {
    logger.error(errorMessage, error: e, stackTrace: s);
    if (context.mounted) {
      messenger.showSnackBar(errorSnackBar(context, errorMessage));
    }
  } finally {
    if (navigator.canPop()) {
      navigator.pop();
    }
  }
}

void _showStripeSetupOverlay(BuildContext context, String message) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return PopScope(
        canPop: false,
        child: AlertDialog.adaptive(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
              ),
              const SizedBox(width: 16),
              Flexible(child: Text(message)),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _launchStripeUrl(String url) async {
  final Uri uri = Uri.parse(url);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception("Could not launch $url");
  }
}

class DisconnectStripeButton extends StatefulWidget {
  final String account;
  final StripeMode stripeMode;
  const DisconnectStripeButton({
    super.key,
    required this.account,
    required this.stripeMode,
  });

  @override
  State<DisconnectStripeButton> createState() => _DisconnectStripeButtonState();
}

class _DisconnectStripeButtonState extends State<DisconnectStripeButton> {
  bool _isDisconnecting = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return OutlinedButton.icon(
      onPressed: _isDisconnecting ? null : () => _confirmDisconnect(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.error,
        side: BorderSide(color: colorScheme.error),
      ),
      icon: _isDisconnecting
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator.adaptive(strokeWidth: 2),
            )
          : const Icon(Icons.link_off_outlined),
      label: Text(_isDisconnecting ? "Disconnecting..." : "Disconnect Stripe"),
    );
  }

  Future<void> _confirmDisconnect(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) =>
          DisconnectStripeDialog(stripeMode: widget.stripeMode),
    );
    if (confirmed != true || !context.mounted) return;
    setState(() => _isDisconnecting = true);
    try {
      await StripeRepository(
        account: widget.account,
      ).disconnectActiveStripeConnection();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(confirmationSnackbar(context, "Stripe disconnected"));
      }
    } catch (e, s) {
      BasicLogger().error(
        "Couldn't disconnect Stripe account",
        error: e,
        stackTrace: s,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackBar(context, "Couldn't disconnect Stripe account"),
        );
      }
    } finally {
      if (mounted) setState(() => _isDisconnecting = false);
    }
  }
}

class DisconnectStripeDialog extends StatelessWidget {
  final StripeMode stripeMode;
  const DisconnectStripeDialog({super.key, required this.stripeMode});

  @override
  Widget build(BuildContext context) {
    final modeLabel = _stripeModeLabel(stripeMode);
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog.adaptive(
      title: const Text("Disconnect Stripe?"),
      content: Text(
        "Checkout will stop for $modeLabel mode. Existing bookings, receipts, and payment records will stay in Mush On. Your Stripe account will not be deleted.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel"),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Disconnect"),
        ),
      ],
    );
  }
}
