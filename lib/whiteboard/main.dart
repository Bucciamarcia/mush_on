import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/home_page/models.dart';
import 'package:mush_on/home_page/whiteboard_element.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/whiteboard/repository.dart';

import 'riverpod.dart';

class GeneralWhiteboard extends ConsumerStatefulWidget {
  static final logger = BasicLogger();
  const GeneralWhiteboard({super.key});

  @override
  ConsumerState<GeneralWhiteboard> createState() => _GeneralWhiteboardState();
}

class _GeneralWhiteboardState extends ConsumerState<GeneralWhiteboard> {
  String _category = "All";
  bool _showDone = false;

  @override
  Widget build(BuildContext context) {
    final elementsAsync = ref.watch(permanentWhiteboardElementsProvider);
    return elementsAsync.when(
      data: (elements) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final sortedElements = elements.toList()
          ..sort(compareWhiteboardElements);
        final visibleElements = sortedElements.where((element) {
          final category = whiteboardCategories.contains(element.category)
              ? element.category
              : "General";
          final categoryMatches = _category == "All" || category == _category;
          final doneMatches = _showDone || !element.isDone;
          return categoryMatches && doneMatches;
        }).toList();
        return ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Standing notes",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () => _showEditor(context),
                        icon: const Icon(Icons.add),
                        label: const Text("Add note"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (final category in ["All", ...whiteboardCategories])
                        ChoiceChip(
                          label: Text(category),
                          selected: _category == category,
                          onSelected: (_) =>
                              setState(() => _category = category),
                        ),
                      FilterChip(
                        label: const Text("Show done"),
                        avatar: const Icon(Icons.check_circle_outline),
                        selected: _showDone,
                        onSelected: (value) =>
                            setState(() => _showDone = value),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (visibleElements.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Text(
                  elements.isEmpty
                      ? "No standing notes yet. Add procedures, reminders, or kennel info staff should keep visible."
                      : "No notes match these filters.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...visibleElements.map(
                (element) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: WhiteboardElementDisplayWidget(
                    element: element,
                    onSaved: _saveElement,
                    onDeleted: _deleteElement,
                  ),
                ),
              ),
          ],
        );
      },
      error: (e, s) {
        GeneralWhiteboard.logger.error(
          "Error loading whiteboard elements",
          error: e,
          stackTrace: s,
        );
        return const Text("Error: couldn't get elements");
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  Future<void> _showEditor(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => WhiteboardElementEditor(
        onSaved: _saveElement,
        onDeleted: _deleteElement,
      ),
    );
  }

  Future<void> _saveElement(WhiteboardElement element) async {
    final repo = PermanentWhiteboardRepository(
      account: await ref.read(accountProvider.future),
    );
    try {
      await repo.setElement(element);
    } catch (e, s) {
      GeneralWhiteboard.logger.error(
        "Error saving whiteboard element",
        error: e,
        stackTrace: s,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(errorSnackBar(context, "Couldn't save element"));
      }
    }
  }

  Future<void> _deleteElement(String id) async {
    final repo = PermanentWhiteboardRepository(
      account: await ref.read(accountProvider.future),
    );
    try {
      await repo.deleteElement(id);
    } catch (e, s) {
      GeneralWhiteboard.logger.error(
        "Error deleting whiteboard element",
        error: e,
        stackTrace: s,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(errorSnackBar(context, "Couldn't delete element"));
      }
    }
  }
}
