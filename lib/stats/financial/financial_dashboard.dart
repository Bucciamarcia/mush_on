import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/partners/repository.dart';
import 'package:mush_on/customer_management/tours/riverpod.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'package:mush_on/stats/financial/logic.dart';
import 'package:mush_on/stats/financial/repository.dart';

/// Musher-only dashboard showing aggregated revenue, commission, outstanding
/// (deferred) receivables and breakdowns by partner / tour type.
class FinancialDashboardScreen extends StatelessWidget {
  const FinancialDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateScreen(
      title: "Financial",
      minUserRank: UserLevel.musher,
      child: FinancialDashboardMain(),
    );
  }
}

/// Bundle of everything the dashboard needs in one load: the records plus the
/// id → display name maps used to label the breakdowns.
class _DashboardData {
  final List<FinancialRecord> records;
  final Map<String, String> partnerNames;
  final Map<String, String> tourTypeNames;

  const _DashboardData({
    required this.records,
    required this.partnerNames,
    required this.tourTypeNames,
  });
}

class FinancialDashboardMain extends ConsumerStatefulWidget {
  const FinancialDashboardMain({super.key});

  @override
  ConsumerState<FinancialDashboardMain> createState() =>
      _FinancialDashboardMainState();
}

class _FinancialDashboardMainState
    extends ConsumerState<FinancialDashboardMain> {
  final BasicLogger logger = BasicLogger();
  late Future<_DashboardData> _future;
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_DashboardData> _load() async {
    final account = await ref.read(accountProvider.future);
    final records = await FinancialRepository(account: account).fetchRecords();
    final partners = await PartnersRepository(account: account).fetchPartners();
    final tourTypes = await ref.read(allTourTypesProvider().future);
    return _DashboardData(
      records: records,
      partnerNames: {for (final p in partners) p.id: p.name},
      tourTypeNames: {for (final t in tourTypes) t.id: t.name},
    );
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _range,
    );
    if (picked != null) {
      // computeFinancialSummary treats `end` as exclusive, so push it to the
      // start of the day after the picked end to make the chosen day inclusive.
      setState(() {
        _range = DateTimeRange(
          start: DateTime(picked.start.year, picked.start.month, picked.start.day),
          end: DateTime(
            picked.end.year,
            picked.end.month,
            picked.end.day,
          ).add(const Duration(days: 1)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DashboardData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          logger.error(
            "Couldn't load financial dashboard",
            error: snapshot.error,
            stackTrace: snapshot.stackTrace,
          );
          return _ErrorState(onRetry: _reload);
        }
        final data = snapshot.requireData;
        final summary = computeFinancialSummary(data.records, range: _range);
        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _RangeBar(
                range: _range,
                onPick: _pickRange,
                onClear: _range == null
                    ? null
                    : () => setState(() => _range = null),
              ),
              const SizedBox(height: 16),
              _SummaryGrid(summary: summary),
              const SizedBox(height: 24),
              _BreakdownCard(
                title: "Revenue by partner",
                emptyLabel: "No revenue in range.",
                rows: _namedRows(
                  summary.revenueByPartner,
                  (key) => key == "direct"
                      ? "Direct (no partner)"
                      : data.partnerNames[key] ?? key,
                ),
              ),
              const SizedBox(height: 16),
              _BreakdownCard(
                title: "Revenue by tour type",
                emptyLabel: "No revenue in range.",
                rows: _namedRows(
                  summary.revenueByTourType,
                  (key) => data.tourTypeNames[key] ?? key,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Turns a {key: cents} map into name-resolved rows sorted high → low.
  List<_BreakdownRow> _namedRows(
    Map<String, int> byKey,
    String Function(String key) nameFor,
  ) {
    final rows = byKey.entries
        .map((e) => _BreakdownRow(label: nameFor(e.key), cents: e.value))
        .toList();
    rows.sort((a, b) => b.cents.compareTo(a.cents));
    return rows;
  }
}

String formatMoney(int cents) => "€${(cents / 100).toStringAsFixed(2)}";

class _RangeBar extends StatelessWidget {
  final DateTimeRange? range;
  final VoidCallback onPick;
  final VoidCallback? onClear;

  const _RangeBar({required this.range, required this.onPick, this.onClear});

  String _format(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final label = range == null
        ? "All time"
        // The stored end is exclusive (start of the day after). Show the
        // inclusive last day to match what the user picked.
        : "${_format(range!.start)} → "
              "${_format(range!.end.subtract(const Duration(days: 1)))}";
    return Row(
      children: [
        const Icon(Icons.event),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (onClear != null)
          IconButton(
            tooltip: "Clear filter",
            onPressed: onClear,
            icon: const Icon(Icons.clear),
          ),
        FilledButton.tonalIcon(
          onPressed: onPick,
          icon: const Icon(Icons.date_range),
          label: const Text("Date range"),
        ),
      ],
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  final FinancialSummary summary;
  const _SummaryGrid({required this.summary});

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[
      _MetricCard(
        label: "Gross revenue",
        value: formatMoney(summary.grossRevenueCents),
        icon: Icons.payments,
        color: Colors.green,
        subtitle: "${summary.paidBookingsCount} paid bookings",
      ),
      _MetricCard(
        label: "Net revenue",
        value: formatMoney(summary.netRevenueCents),
        icon: Icons.account_balance_wallet,
        color: Colors.teal,
        subtitle: "After commission",
      ),
      _MetricCard(
        label: "Commission",
        value: formatMoney(summary.commissionCents),
        icon: Icons.percent,
        color: Colors.orange,
        subtitle: "On-platform only",
      ),
      _MetricCard(
        label: "Outstanding",
        value: formatMoney(summary.outstandingDeferredCents),
        icon: Icons.hourglass_bottom,
        color: Colors.blue,
        subtitle: "Deferred (unpaid)",
      ),
      _MetricCard(
        label: "Refunded",
        value: formatMoney(summary.refundedCents),
        icon: Icons.undo,
        color: Colors.red,
        subtitle: "Excluded from revenue",
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        // Aim for ~220px-wide cards, at least one column.
        final columns = (constraints.maxWidth / 220).floor().clamp(1, 4);
        const spacing = 12.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final card in cards) SizedBox(width: width, child: card),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow {
  final String label;
  final int cents;
  const _BreakdownRow({required this.label, required this.cents});
}

class _BreakdownCard extends StatelessWidget {
  final String title;
  final String emptyLabel;
  final List<_BreakdownRow> rows;

  const _BreakdownCard({
    required this.title,
    required this.emptyLabel,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            if (rows.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  emptyLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              )
            else
              for (final row in rows)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(child: Text(row.label)),
                      Text(
                        formatMoney(row.cents),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          const Text("Couldn't load financial data."),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}
