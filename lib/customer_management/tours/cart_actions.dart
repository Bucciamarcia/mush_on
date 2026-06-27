import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';

class TourCartActions extends ConsumerWidget {
  final String tourId;
  final MainAxisAlignment alignment;

  const TourCartActions({
    super.key,
    required this.tourId,
    this.alignment = MainAxisAlignment.end,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider).valueOrNull;
    final isReady = account != null && account.isNotEmpty;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: [
        FilledButton.icon(
          onPressed: isReady
              ? () => context.go(_cartPath(account: account, tourId: tourId))
              : null,
          icon: const Icon(Icons.shopping_cart_checkout),
          label: const Text("Go to cart"),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: "copy cart url",
          child: IconButton(
            onPressed: isReady
                ? () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: _cartUrl(account: account, tourId: tourId),
                      ),
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      confirmationSnackbar(context, "Cart URL copied"),
                    );
                  }
                : null,
            icon: const Icon(Icons.copy),
          ),
        ),
      ],
    );
  }
}

String _cartPath({required String account, required String tourId}) {
  return Uri(
    path: "/booking",
    queryParameters: {"kennel": account, "tourId": tourId},
  ).toString();
}

String _cartUrl({required String account, required String tourId}) {
  final base = Uri.base;
  if ((base.scheme == "http" || base.scheme == "https") &&
      base.host.isNotEmpty) {
    return base
        .replace(
          path: "/booking",
          queryParameters: {"kennel": account, "tourId": tourId},
          fragment: "",
        )
        .toString();
  }
  return _cartPath(account: account, tourId: tourId);
}
