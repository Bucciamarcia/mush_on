import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/home_page/repository.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/services/riverpod/dog_notes.dart';
import 'package:mush_on/shared/dog_list_alert_dialog.dart';
import 'package:mush_on/tasks/tab_bar_widgets/sf_schedule_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'models.dart';
import 'riverpod.dart';
import 'whiteboard_element.dart';

class HomePageScreenContent extends ConsumerWidget {
  static final logger = BasicLogger();
  const HomePageScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HomePageRiverpodResults> riverpodAsync = ref.watch(
      homePageRiverpodProvider,
    );
    return riverpodAsync.when(
      data: (riverpod) {
        String? account = ref.watch(accountProvider).value;
        List<Dog> dogs = riverpod.dogs;
        List<DogNote> dogNotes = ref.watch(dogNotesProvider(latestDate: null));
        TasksInMemory tasks = riverpod.tasks;
        int unavailable = 0;
        int warningOnly = 0;
        int ok = 0;

        for (final dog in dogs) {
          final notes = dogNotes.where((n) => n.dogId == dog.id);

          final hasFatal = notes.any(
            (n) =>
                n.dogNoteMessage.any((m) => m.type.noteType == NoteType.fatal),
          );
          final hasWarning = notes.any(
            (n) => n.dogNoteMessage.any(
              (m) => m.type.noteType == NoteType.warning,
            ),
          );

          if (hasFatal) {
            unavailable++;
          } else if (hasWarning) {
            warningOnly++;
          } else {
            ok++;
          }
        }

        final canRun = ok + warningOnly; // ready-to-run number
        final fatalDogIds = dogNotes
            .typeFatal()
            .map((note) => note.dogId)
            .toSet();
        final cannotRunDogs = dogs
            .where((dog) => fatalDogIds.contains(dog.id))
            .toList();
        final healthEventDogs = <Dog>[];
        for (final event in riverpod.healthEvents.active) {
          final dog = dogs.getDogFromId(event.dogId);
          if (dog != null && !healthEventDogs.contains(dog)) {
            healthEventDogs.add(dog);
          }
        }
        final heatDogs = <Dog>[];
        for (final event in riverpod.heatCycles.active) {
          final dog = dogs.getDogFromId(event.dogId);
          if (dog != null && !heatDogs.contains(dog)) {
            heatDogs.add(dog);
          }
        }
        List<WhiteboardElement> whiteboardElements =
            riverpod.whiteboardElements.toList()
              ..sort(compareWhiteboardElements);
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final totalDogs = dogs.length;
        final healthEventCount = riverpod.healthEvents.active.length;
        final inHeatCount = riverpod.heatCycles.active.length;
        final formattedToday = DateFormat("EEE, MMM d").format(DateTime.now());

        return ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          children: [
            (kDebugMode) ? const ConvertTeamGroup() : const SizedBox.shrink(),
            _DashboardPanel(
              child: Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  initiallyExpanded: true,
                  title: _SectionHeader(
                    icon: Icons.note_alt_outlined,
                    title: "Daily whiteboard",
                    subtitle: formattedToday,
                    action: AddWhiteboardElementDisplayWidget(
                      onDeleted: (_) {},
                      onSaved: (e) {
                        if (account == null) {
                          logger.warning("Couldn't load account in home page");
                          ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(
                              context,
                              "Error: couldn't load account",
                            ),
                          );
                        } else {
                          try {
                            WhiteboardElementRepository(
                              account: account,
                            ).addElement(e);
                          } catch (e, s) {
                            logger.error(
                              "couldn't add element",
                              error: e,
                              stackTrace: s,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar(
                                context,
                                "Error: couldn't add element",
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  children: [
                    if (whiteboardElements.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colors.outlineVariant),
                        ),
                        child: Text(
                          "No notes yet for today.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      )
                    else
                      ...whiteboardElements.map(
                        (element) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SizedBox(
                            width: double.infinity,
                            child: WhiteboardElementDisplayWidget(
                              element: element,
                              onDeleted: (id) {
                                if (account == null) {
                                  logger.warning(
                                    "Couldn't load account in home page",
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    errorSnackBar(
                                      context,
                                      "Error: couldn't load account",
                                    ),
                                  );
                                } else {
                                  try {
                                    WhiteboardElementRepository(
                                      account: account,
                                    ).deleteElement(id);
                                  } catch (e, s) {
                                    logger.error(
                                      "couldn't delete element",
                                      error: e,
                                      stackTrace: s,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      errorSnackBar(
                                        context,
                                        "Error: couldn't delete element",
                                      ),
                                    );
                                  }
                                }
                              },
                              onSaved: (e) {
                                if (account == null) {
                                  logger.warning(
                                    "Couldn't load account in home page",
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    errorSnackBar(
                                      context,
                                      "Error: couldn't load account",
                                    ),
                                  );
                                } else {
                                  try {
                                    WhiteboardElementRepository(
                                      account: account,
                                    ).addElement(e);
                                  } catch (e, s) {
                                    logger.error(
                                      "couldn't add element",
                                      error: e,
                                      stackTrace: s,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      errorSnackBar(
                                        context,
                                        "Error: couldn't add element",
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _DashboardPanel(
              child: Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  initiallyExpanded: true,
                  title: const _SectionHeader(
                    icon: Icons.access_time,
                    title: "Today's tasks",
                  ),
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 760;
                        final summaryCards = [
                          _SummaryCardData(
                            label: "READY",
                            value: canRun,
                            caption: "of $totalDogs dogs",
                            color: const Color(0xFF22B35D),
                          ),
                          _SummaryCardData(
                            label: "CANNOT RUN",
                            value: unavailable,
                            caption: "Needs attention",
                            color: const Color(0xFFE34B4B),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => DogListAlertDialog(
                                title: "Dogs that can't run",
                                dogs: cannotRunDogs,
                              ),
                            ),
                            buttonLabel: "Show dogs",
                          ),
                          _SummaryCardData(
                            label: "IN HEAT",
                            value: inHeatCount,
                            caption: "Monitor closely",
                            color: const Color(0xFFE4A11B),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => DogListAlertDialog(
                                title: "Dogs in heat",
                                dogs: heatDogs,
                              ),
                            ),
                            buttonLabel: "Show dogs",
                          ),
                          _SummaryCardData(
                            label: "HEALTH EVENTS",
                            value: healthEventCount,
                            caption: healthEventCount == 0
                                ? "All clear"
                                : "Active cases",
                            color: const Color(0xFF97A2B8),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => DogListAlertDialog(
                                title: "Dogs with health events",
                                dogs: healthEventDogs,
                              ),
                            ),
                            buttonLabel: "Show dogs",
                          ),
                        ];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: summaryCards.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: compact ? 2 : 4,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    mainAxisExtent: compact ? 132 : 142,
                                  ),
                              itemBuilder: (context, index) {
                                final item = summaryCards[index];
                                return _SummaryCard(item: item);
                              },
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: colors.outlineVariant),
                                  bottom: BorderSide(
                                    color: colors.outlineVariant,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: compact ? 14 : 18,
                              ),
                              child: compact
                                  ? Column(
                                      children: [
                                        _ReadinessDonut(
                                          ok: ok,
                                          warningOnly: warningOnly,
                                          unavailable: unavailable,
                                          totalDogs: totalDogs,
                                        ),
                                        const SizedBox(height: 18),
                                        _ReadinessLegend(
                                          ok: ok,
                                          warningOnly: warningOnly,
                                          unavailable: unavailable,
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        _ReadinessDonut(
                                          ok: ok,
                                          warningOnly: warningOnly,
                                          unavailable: unavailable,
                                          totalDogs: totalDogs,
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: _ReadinessLegend(
                                            ok: ok,
                                            warningOnly: warningOnly,
                                            unavailable: unavailable,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: _getTextColor(canRun, totalDogs),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Ready to run",
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: colors.onSurfaceVariant,
                                        ),
                                  ),
                                ),
                                FilledButton.icon(
                                  onPressed: () => context.go("/createteam"),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF121A2A),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.pets_outlined,
                                    size: 18,
                                  ),
                                  label: const Text("Build team"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: ColoredBox(
                                color: colors.surface,
                                child: SfScheduleView(
                                  tasks: tasks.dueToday,
                                  onFetchOlderTasks: (date) {},
                                  onTaskDeleted: (tid) async =>
                                      TaskRepository.delete(
                                        tid,
                                        await ref.watch(accountProvider.future),
                                      ),
                                  dogs: dogs,
                                  date: DateTime.now(),
                                  onTaskEdited: (t) async =>
                                      TaskRepository.addOrUpdate(
                                        t,
                                        await ref.watch(accountProvider.future),
                                      ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      error: (e, s) {
        BasicLogger().error(
          "Couldn't load warning dogs async in home page",
          error: e,
          stackTrace: s,
        );
        return const Text("Couldn't load the page! Try to reload");
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  Color _getTextColor(int canRun, int totalDogs) {
    if (totalDogs == 0) {
      return Colors.green;
    }
    if (canRun / totalDogs < 0.75) {
      return Colors.red;
    } else if (canRun / totalDogs >= 0.75 && canRun / totalDogs <= 0.9) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}

class ConvertTeamGroup extends StatefulWidget {
  const ConvertTeamGroup({super.key});

  @override
  State<ConvertTeamGroup> createState() => _ConvertTeamGroupState();
}

class _ConvertTeamGroupState extends State<ConvertTeamGroup> {
  late TextEditingController c;
  @override
  void initState() {
    c = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 400, child: TextField(controller: c)),
        ElevatedButton(
          onPressed: () async {
            final functions = FirebaseFunctions.instanceFor(
              region: "europe-north1",
            );
            try {
              final response = await functions
                  .httpsCallable("rebuild_teamgroup_teams_snapshot")
                  .call({
                    "teamgroupPath":
                        "accounts/test-stefano/data/teams/history/${c.text}",
                  });
              BasicLogger().debug(response.data);
            } catch (e, s) {
              BasicLogger().error("Couldn't do it", error: e, stackTrace: s);
            }
          },
          child: const Text("gogo"),
        ),
      ],
    );
  }
}

class ReadyDogData {
  ReadyDogData(this.x, this.y, this.color);
  final String x;
  final int y;
  final Color color;
}

class _DashboardPanel extends StatelessWidget {
  const _DashboardPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 10),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        action ?? const SizedBox.shrink(),
      ],
    );
  }
}

class _SummaryCardData {
  const _SummaryCardData({
    required this.label,
    required this.value,
    required this.caption,
    required this.color,
    this.buttonLabel,
    this.onPressed,
  });

  final String label;
  final int value;
  final String caption;
  final Color color;
  final String? buttonLabel;
  final VoidCallback? onPressed;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.item});

  final _SummaryCardData item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: item.color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: item.color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.label,
            style: theme.textTheme.labelMedium?.copyWith(
              letterSpacing: 0.8,
              color: item.color.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${item.value}",
            style: theme.textTheme.headlineMedium?.copyWith(
              height: 0.95,
              color: item.color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.circle, size: 7, color: item.color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.caption,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: item.color.withValues(alpha: 0.75),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          if (item.buttonLabel != null) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: item.value == 0 ? null : item.onPressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 24),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: item.color,
                ),
                child: Text(item.buttonLabel!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReadinessDonut extends StatelessWidget {
  const _ReadinessDonut({
    required this.ok,
    required this.warningOnly,
    required this.unavailable,
    required this.totalDogs,
  });

  final int ok;
  final int warningOnly;
  final int unavailable;
  final int totalDogs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 170,
      height: 140,
      child: SfCircularChart(
        margin: EdgeInsets.zero,
        annotations: [
          CircularChartAnnotation(
            widget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$ok",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF162238),
                  ),
                ),
                Text(
                  "/ ${totalDogs == 0 ? 0 : totalDogs}",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
        series: <CircularSeries>[
          DoughnutSeries<ReadyDogData, String>(
            radius: "90%",
            innerRadius: "72%",
            strokeWidth: 0,
            dataSource: <ReadyDogData>[
              ReadyDogData("OK", ok, const Color(0xFF21AD56)),
              ReadyDogData("Warning", warningOnly, const Color(0xFFE48A11)),
              ReadyDogData("Unavailable", unavailable, const Color(0xFFDE3737)),
            ],
            xValueMapper: (ReadyDogData data, _) => data.x,
            yValueMapper: (ReadyDogData data, _) => data.y,
            pointColorMapper: (ReadyDogData data, _) => data.color,
          ),
        ],
      ),
    );
  }
}

class _ReadinessLegend extends StatelessWidget {
  const _ReadinessLegend({
    required this.ok,
    required this.warningOnly,
    required this.unavailable,
  });

  final int ok;
  final int warningOnly;
  final int unavailable;

  @override
  Widget build(BuildContext context) {
    final total = ok + warningOnly + unavailable;
    return Column(
      children: [
        _LegendBar(
          label: "OK",
          value: ok,
          total: total,
          color: const Color(0xFF21AD56),
        ),
        const SizedBox(height: 12),
        _LegendBar(
          label: "Warning",
          value: warningOnly,
          total: total,
          color: const Color(0xFFE48A11),
        ),
        const SizedBox(height: 12),
        _LegendBar(
          label: "Unavailable",
          value: unavailable,
          total: total,
          color: const Color(0xFFDE3737),
        ),
      ],
    );
  }
}

class _LegendBar extends StatelessWidget {
  const _LegendBar({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
  });

  final String label;
  final int value;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : value / total;
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 108,
          child: Row(
            children: [
              Icon(Icons.circle, size: 8, color: color),
              const SizedBox(width: 10),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 5,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 24,
          child: Text(
            "$value",
            textAlign: TextAlign.right,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF162238),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
