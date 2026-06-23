import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/section_shell.dart';
import 'package:mush_on/settings/stripe/shopping_cart_settings.dart';
import 'package:mush_on/settings/stripe/stripe_account_selectors.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'package:mush_on/settings/stripe/stripe_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'riverpod.dart';

final stripeConnectionStatusProvider =
    FutureProvider.family<StripeConnectionStatus, String>((ref, account) {
      ref.watch(selectedStripeModeProvider);
      ref.watch(stripeIntegrationActiveProvider);
      ref.watch(stripeAccountsProvider);
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
      final selectedModeAsync = ref.watch(selectedStripeModeProvider);
      final integrationActiveAsync = ref.watch(stripeIntegrationActiveProvider);
      final accountsAsync = ref.watch(stripeAccountsProvider);
      if (selectedModeAsync.isLoading ||
          integrationActiveAsync.isLoading ||
          accountsAsync.isLoading) {
        return const CircularProgressIndicator.adaptive();
      }
      if (selectedModeAsync.hasError) {
        logger.error(
          "Error loading Stripe mode",
          error: selectedModeAsync.error,
          stackTrace: selectedModeAsync.stackTrace,
        );
        return Text("Error loading Stripe mode: ${selectedModeAsync.error}");
      }
      if (accountsAsync.hasError) {
        logger.error(
          "Error loading Stripe accounts",
          error: accountsAsync.error,
          stackTrace: accountsAsync.stackTrace,
        );
        return Text("Error loading Stripe accounts: ${accountsAsync.error}");
      }
      if (integrationActiveAsync.hasError) {
        logger.error(
          "Error loading Stripe activation",
          error: integrationActiveAsync.error,
          stackTrace: integrationActiveAsync.stackTrace,
        );
        return Text(
          "Error loading Stripe activation: ${integrationActiveAsync.error}",
        );
      }
      final selectedMode = selectedModeAsync.value ?? StripeMode.test;
      final integrationActive = integrationActiveAsync.value ?? false;
      final accounts = accountsAsync.value ?? const <StripeAccount>[];
      final connected = connectedAccountForMode(accounts, selectedMode);
      final archived = archivedAccountsForMode(accounts, selectedMode);
      final panel = StripeConnectionPanel(
        account: account,
        selectedMode: selectedMode,
        integrationActive: integrationActive,
        connected: connected,
        archivedAccounts: archived,
      );
      if (connected == null) {
        return panel;
      }
      final statusAsync = ref.watch(stripeConnectionStatusProvider(account));
      return statusAsync.when(
        data: (status) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 18,
          children: [
            StripeConnectionPanel(
              account: account,
              selectedMode: selectedMode,
              integrationActive: integrationActive,
              connected: connected,
              archivedAccounts: archived,
              status: status,
            ),
            if (status.isReady) const ShoppingCartSettings(),
          ],
        ),
        error: (e, s) {
          logger.error("Error loading stripe status", error: e, stackTrace: s);
          return StripeConnectionPanel(
            account: account,
            selectedMode: selectedMode,
            integrationActive: integrationActive,
            connected: connected,
            archivedAccounts: archived,
            statusError: e,
          );
        },
        loading: () => StripeConnectionPanel(
          account: account,
          selectedMode: selectedMode,
          integrationActive: integrationActive,
          connected: connected,
          archivedAccounts: archived,
          isCheckingStatus: true,
        ),
      );
    }
  }
}

String _stripeModeLabel(StripeMode mode) {
  return mode == StripeMode.live ? "Live" : "Test";
}

class StripeConnectionPanel extends ConsumerStatefulWidget {
  final String account;
  final StripeMode selectedMode;
  final bool integrationActive;
  final StripeAccount? connected;
  final List<StripeAccount> archivedAccounts;
  final StripeConnectionStatus? status;
  final Object? statusError;
  final bool isCheckingStatus;
  const StripeConnectionPanel({
    super.key,
    required this.account,
    required this.selectedMode,
    required this.integrationActive,
    required this.connected,
    required this.archivedAccounts,
    this.status,
    this.statusError,
    this.isCheckingStatus = false,
  });

  @override
  ConsumerState<StripeConnectionPanel> createState() =>
      _StripeConnectionPanelState();
}

class _StripeConnectionPanelState extends ConsumerState<StripeConnectionPanel> {
  bool _isSwitchingMode = false;
  bool _isRefreshing = false;
  bool _isChangingActivation = false;
  StripeMode? _pendingMode;

  StripeMode get _displayedMode => _pendingMode ?? widget.selectedMode;

  @override
  void didUpdateWidget(covariant StripeConnectionPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_pendingMode == widget.selectedMode) {
      _pendingMode = null;
      _isSwitchingMode = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAccount =
        widget.status?.hasAccount ??
        widget.connected?.accountId.isNotEmpty == true;
    final isReady = widget.status?.isReady == true;
    final modeLabel = _stripeModeLabel(widget.selectedMode);
    final title = widget.isCheckingStatus
        ? "Checking Stripe setup"
        : isReady
        ? "$modeLabel mode ready"
        : hasAccount
        ? "Stripe setup is not complete"
        : "$modeLabel mode not connected";
    final body = widget.statusError != null
        ? "Couldn't refresh Stripe setup status. You can continue setup or disconnect Stripe."
        : widget.isCheckingStatus
        ? "Checking whether this Stripe account can accept payments."
        : isReady
        ? "Checkout can use this Stripe connection while $modeLabel mode is active."
        : hasAccount
        ? widget.status?.reason ??
              "Stripe needs more setup before checkout can be enabled."
        : "Connect Stripe before configuring checkout for $modeLabel mode.";
    final icon = widget.isCheckingStatus
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SegmentedButton<StripeMode>(
                key: const Key('stripeModeToggle'),
                segments: const [
                  ButtonSegment(value: StripeMode.test, label: Text("Test")),
                  ButtonSegment(value: StripeMode.live, label: Text("Live")),
                ],
                selected: {_displayedMode},
                onSelectionChanged: _isSwitchingMode
                    ? null
                    : (selection) => _setSelectedMode(selection.first),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: _isRefreshing ? null : _refreshConnection,
                icon: _isRefreshing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.refresh_outlined),
                label: const Text("Refresh connection"),
              ),
            ),
            if (_isSwitchingMode) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
            ],
            const SizedBox(height: 12),
            Wrap(
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
                if (widget.isCheckingStatus)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                  )
                else if (hasAccount)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (!isReady)
                        ContinueStripeSetupButton(
                          account: widget.account,
                          stripeMode: widget.selectedMode,
                        ),
                      if (widget.connected != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Accept payments globally"),
                            Switch.adaptive(
                              key: const Key('paymentsActiveToggle'),
                              value: widget.integrationActive,
                              onChanged: _isChangingActivation
                                  ? null
                                  : _setPaymentsActive,
                            ),
                            if (_isChangingActivation)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2,
                                ),
                              ),
                          ],
                        ),
                      DisconnectStripeButton(
                        account: widget.account,
                        stripeMode: widget.selectedMode,
                      ),
                    ],
                  )
                else
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ConnectStripeButton(
                        account: widget.account,
                        stripeMode: widget.selectedMode,
                      ),
                      if (widget.archivedAccounts.isNotEmpty)
                        ReconnectStripeAccountButton(
                          account: widget.account,
                          stripeMode: widget.selectedMode,
                          archivedAccounts: widget.archivedAccounts,
                        ),
                    ],
                  ),
              ],
            ),
            if (widget.connected != null) ...[
              const SizedBox(height: 12),
              Text(
                "Connected account: ${widget.connected!.accountId}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (widget.archivedAccounts.isNotEmpty) ...[
              const SizedBox(height: 16),
              Column(
                children: [
                  for (final archived in widget.archivedAccounts)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(archived.accountId),
                      subtitle: const Text(
                        "reconnect a previously used Stripe account",
                      ),
                      trailing: IconButton(
                        key: Key('deleteArchivedAccount_${archived.accountId}'),
                        tooltip: "Delete",
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDeleteArchivedAccount(
                          context,
                          widget.account,
                          archived.accountId,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _setSelectedMode(StripeMode mode) async {
    if (mode == widget.selectedMode) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _pendingMode = mode;
      _isSwitchingMode = true;
    });
    try {
      await StripeRepository(account: widget.account).setSelectedMode(mode);
      ref.invalidate(selectedStripeModeProvider);
      ref.invalidate(stripeIntegrationActiveProvider);
      ref.invalidate(stripeConnectionStatusProvider(widget.account));
    } catch (e, s) {
      BasicLogger().error("Couldn't set Stripe mode", error: e, stackTrace: s);
      if (mounted) {
        messenger.showSnackBar(
          errorSnackBar(context, "Couldn't set Stripe mode"),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSwitchingMode = false;
          _pendingMode = null;
        });
      }
    }
  }

  Future<void> _refreshConnection() async {
    setState(() => _isRefreshing = true);
    try {
      ref.invalidate(selectedStripeModeProvider);
      ref.invalidate(stripeIntegrationActiveProvider);
      ref.invalidate(stripeAccountsProvider);
      ref.invalidate(stripeConnectionStatusProvider(widget.account));
      if (widget.connected != null) {
        await ref.read(stripeConnectionStatusProvider(widget.account).future);
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  Future<void> _setPaymentsActive(bool value) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isChangingActivation = true);
    try {
      await StripeRepository(
        account: widget.account,
      ).changeStripeIntegrationActivation(value);
      ref.invalidate(stripeIntegrationActiveProvider);
      ref.invalidate(stripeConnectionStatusProvider(widget.account));
      await ref.read(stripeIntegrationActiveProvider.future);
    } catch (e, s) {
      BasicLogger().error(
        "Couldn't change Stripe activation",
        error: e,
        stackTrace: s,
      );
      if (mounted) {
        messenger.showSnackBar(
          errorSnackBar(context, "Couldn't change Stripe activation"),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isChangingActivation = false);
      }
    }
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
      label: Text(_isConnecting ? "Connecting..." : "Create a Stripe account"),
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

class ReconnectStripeAccountButton extends StatelessWidget {
  final String account;
  final StripeMode stripeMode;
  final List<StripeAccount> archivedAccounts;

  const ReconnectStripeAccountButton({
    super.key,
    required this.account,
    required this.stripeMode,
    required this.archivedAccounts,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _showReconnectDialog(context),
      icon: const Icon(Icons.restore_outlined),
      label: const Text("Reconnect Stripe account"),
    );
  }

  Future<void> _showReconnectDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog.adaptive(
          title: const Text("Reconnect Stripe account"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("reconnect a previously used Stripe account"),
              const SizedBox(height: 12),
              for (final archived in archivedAccounts)
                ListTile(
                  title: Text(archived.accountId),
                  onTap: () async {
                    await StripeRepository(
                      account: account,
                    ).reconnectStripeAccount(
                      accountId: archived.accountId,
                      stripeMode: stripeMode,
                    );
                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}

Future<void> _confirmDeleteArchivedAccount(
  BuildContext context,
  String account,
  String accountId,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final colorScheme = Theme.of(dialogContext).colorScheme;
      return AlertDialog.adaptive(
        title: const Text("Delete Stripe account?"),
        content: const Text(
          "WARNING: This Stripe account cannot be retrieved after deletion!",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
  if (confirmed == true && context.mounted) {
    await StripeRepository(
      account: account,
    ).deleteStripeAccount(accountId: accountId);
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
      ).disconnectStripeAccount(stripeMode: widget.stripeMode);
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
