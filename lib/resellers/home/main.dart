import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/resellers/create_account/riverpod.dart';
import 'package:mush_on/resellers/home/resell_calendar.dart';
import 'package:mush_on/resellers/home/riverpod.dart';
import 'package:mush_on/resellers/invite_resellers/repository.dart';
import 'package:mush_on/resellers/reseller_template.dart';
import 'package:mush_on/services/error_handling.dart';

class ResellerMain extends StatelessWidget {
  const ResellerMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 20,
      children: [
        SelectAccountToResell(),
        ResellCalendar(),
      ],
    );
  }
}

class SelectAccountToResell extends ConsumerWidget {
  const SelectAccountToResell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = BasicLogger();
    final resellerAsync = ref.watch(resellerProvider);
    return resellerAsync.when(
        data: (reseller) {
          if (reseller == null) {
            return const ResellerError(message: "Reseller account is null");
          }
          final accountsList = reseller.resellerAccounts;
          if (accountsList.isEmpty) return const SizedBox.shrink();
          return DropdownMenu<AccountAndDiscount>(
            initialSelection: reseller.resellerAccounts[0],
            dropdownMenuEntries: reseller.resellerAccounts
                .map((acc) =>
                    DropdownMenuEntry(value: acc, label: acc.accountName))
                .toList(),
            onSelected: (v) {
              if (v != null) {
                ref.read(accountToResellProvider.notifier).change(v);
              }
            },
          );
        },
        error: (e, s) {
          logger.error("Couldn't retrieve reseller provider",
              error: e, stackTrace: s);
          return const Text("Error: couldn't load data from database");
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}
