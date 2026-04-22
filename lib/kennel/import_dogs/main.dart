import 'package:file_picker/file_picker.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mush_on/kennel/import_dogs/datagrid.dart';
import 'package:mush_on/kennel/import_dogs/models.dart';
import 'package:mush_on/kennel/import_dogs/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/shared/upload_document/main.dart';

class ImportDogsMain extends ConsumerStatefulWidget {
  const ImportDogsMain({super.key});

  @override
  ConsumerState<ImportDogsMain> createState() => _ImportDogsMainState();
}

class _ImportDogsMainState extends ConsumerState<ImportDogsMain> {
  late bool isExtracting;
  late bool isImporting;
  int importedCount = 0;
  int totalToImport = 0;
  int failedImports = 0;
  PlatformFile? platformFile;

  @override
  void initState() {
    isExtracting = false;
    isImporting = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dogsToImport = ref.watch(dogsToImportStateProvider);
    final selectedCount = dogsToImport.where((dog) => dog.import).length;
    final duplicatesCount = dogsToImport
        .where((dog) => dog.isNameDuplicate)
        .length;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primaryContainer,
                colorScheme.surfaceContainerHighest,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.primary,
                  child: Icon(
                    Icons.upload_file_rounded,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Bulk import kennel dogs",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Upload a PDF or CSV, review the names detected by AI, and import only the dogs you want to keep.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _InfoChip(
                      icon: Icons.description_outlined,
                      label: platformFile?.name ?? "No file selected yet",
                    ),
                    const _InfoChip(
                      icon: Icons.auto_awesome_outlined,
                      label: "AI-assisted extraction",
                    ),
                    const _InfoChip(
                      icon: Icons.rule_folder_outlined,
                      label: "PDF and CSV supported",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Step 1 · Upload and scan",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "The file is parsed first. Then you can review every detected dog before importing.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                IgnorePointer(
                  ignoring: isExtracting || isImporting,
                  child: Opacity(
                    opacity: isExtracting || isImporting ? 0.65 : 1,
                    child: UploadDocumentWidget(
                      onDocumentSelected: (f) {
                        setState(() {
                          platformFile = f;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: isExtracting || isImporting
                        ? null
                        : () async {
                            final result = await _callGemini();
                            if (result != null) {
                              await ref
                                  .read(dogsToImportStateProvider.notifier)
                                  .fromDogResults(result);
                            }
                          },
                    icon: isExtracting
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : const Icon(Icons.search_rounded),
                    label: Text(
                      isExtracting
                          ? "Reading document..."
                          : "Scan file for dogs",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (dogsToImport.isNotEmpty) ...[
          const SizedBox(height: 20),
          Card(
            elevation: 0,
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Step 2 · Review and import",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Existing dog names are deselected automatically. Double-check the extracted list before you start the import.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _StatTile(
                        label: "Detected",
                        value: dogsToImport.length.toString(),
                        icon: Icons.pets_outlined,
                        tint: colorScheme.primaryContainer,
                      ),
                      _StatTile(
                        label: "Selected",
                        value: selectedCount.toString(),
                        icon: Icons.check_circle_outline,
                        tint: const Color(0xFFDCEFE2),
                      ),
                      _StatTile(
                        label: "Duplicates",
                        value: duplicatesCount.toString(),
                        icon: Icons.warning_amber_rounded,
                        tint: const Color(0xFFFFE7C2),
                      ),
                    ],
                  ),
                  if (isImporting) ...[
                    const SizedBox(height: 20),
                    _ImportProgressPanel(
                      importedCount: importedCount,
                      totalToImport: totalToImport,
                      failedImports: failedImports,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: ImportDogsDatagrid(
                      dogsToImport: dogsToImport,
                      enabled: !isImporting,
                      onValueFlipped: (i, v) => ref
                          .read(dogsToImportStateProvider.notifier)
                          .flipDog(i, v),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed:
                          selectedCount == 0 || isImporting || isExtracting
                          ? null
                          : () => _importSelectedDogs(dogsToImport),
                      icon: isImporting
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : const Icon(Icons.cloud_upload_rounded),
                      label: Text(
                        isImporting
                            ? "Importing dogs..."
                            : "Import selected dogs",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<ImportDogResult?> _callGemini() async {
    final jsonSchema = GeminiSchema.schema;
    setState(() {
      isExtracting = true;
    });
    final model = FirebaseAI.googleAI().generativeModel(
      model: "gemini-3-flash-preview",
      generationConfig: GenerationConfig(
        responseMimeType: "application/json",
        responseSchema: jsonSchema,
      ),
    );
    if (platformFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(errorSnackBar(context, "There is no file selected"));
      setState(() {
        isExtracting = false;
      });
      return null;
    }
    final bytes = platformFile!.bytes;
    if (bytes == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(errorSnackBar(context, "File bytes are empty"));
      setState(() {
        isExtracting = false;
      });
      return null;
    }
    if (!["pdf", "csv"].contains(platformFile!.extension)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(errorSnackBar(context, "Unsupported file format"));
      setState(() {
        isExtracting = false;
      });
      return null;
    }
    final mimeType = platformFile!.extension == "pdf"
        ? "application/pdf"
        : "text/csv";
    final docPart = InlineDataPart(mimeType, bytes);
    const prompt = TextPart("Generate a list of dogs in this document");
    try {
      final response = await model.generateContent([
        Content.multi([prompt, docPart]),
      ]);
      final text = response.text;
      if (text == null) {
        throw Exception("No text returned from Gemini");
      }
      final imported = ImportDogResult.decode(text);
      BasicLogger().debug("Dogs importe: ${imported.length}");
      setState(() {
        isExtracting = false;
      });
      return imported;
    } catch (e, s) {
      BasicLogger().error("Couldn't generate content", error: e, stackTrace: s);
      setState(() {
        isExtracting = false;
      });
      return null;
    }
  }

  Future<void> _importSelectedDogs(List<DogToImport> dogsToImport) async {
    final selectedDogs = dogsToImport.where((dog) => dog.import).toList();
    if (selectedDogs.isEmpty) {
      return;
    }

    setState(() {
      isImporting = true;
      importedCount = 0;
      totalToImport = selectedDogs.length;
      failedImports = 0;
    });

    final account = await ref.read(accountProvider.future);

    for (final dogToImport in selectedDogs) {
      try {
        await FirestoreService().addDogToDb(dogToImport.dog, null, account);
        if (!mounted) {
          return;
        }
        setState(() {
          importedCount += 1;
        });
      } catch (e, s) {
        BasicLogger().error(
          "Couldn't add dog in mass import",
          error: e,
          stackTrace: s,
        );
        if (!mounted) {
          return;
        }
        setState(() {
          failedImports += 1;
        });
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      isImporting = false;
    });

    if (failedImports > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          context,
          "Imported $importedCount of $totalToImport dogs. $failedImports failed.",
        ),
      );
    }
    context.go("/editkennel");
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color tint;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 140),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportProgressPanel extends StatelessWidget {
  final int importedCount;
  final int totalToImport;
  final int failedImports;

  const _ImportProgressPanel({
    required this.importedCount,
    required this.totalToImport,
    required this.failedImports,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = totalToImport == 0 ? 0.0 : importedCount / totalToImport;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sync_rounded, color: colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Importing dogs one by one",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                "$importedCount / $totalToImport",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: colorScheme.surface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            failedImports == 0
                ? "Please keep this page open until the import completes."
                : "$failedImports dogs failed and were skipped. The rest will continue.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
