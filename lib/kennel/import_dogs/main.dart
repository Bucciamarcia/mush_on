import 'package:file_picker/file_picker.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late bool isLoading;
  late TextEditingController pathController;
  PlatformFile? platformFile;
  @override
  void initState() {
    isLoading = false;
    pathController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dogsToImport = ref.watch(dogsToImportStateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UploadDocumentWidget(
          onDocumentSelected: (f) {
            setState(() {
              platformFile = f;
            });
          },
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  final result = await _callGemini();
                  if (result != null) {
                    await ref
                        .read(dogsToImportStateProvider.notifier)
                        .fromDogResults(result);
                  }
                },
          child: isLoading
              ? const CircularProgressIndicator()
              : const Text("test"),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: dogsToImport.isNotEmpty
              ? Center(
                  child: Column(
                    children: [
                      const Text(
                        "If a dog name already exists, it will be deselected by default",
                      ),
                      const Text(
                        "Notice: this is an AI feature, please check the results before importing.",
                      ),
                      ImportDogsDatagrid(
                        dogsToImport: dogsToImport,
                        onValueFlipped: (i, v) => ref
                            .read(dogsToImportStateProvider.notifier)
                            .flipDog(i, v),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final account = await ref.watch(
                            accountProvider.future,
                          );
                          for (final dogToImport in dogsToImport) {
                            if (dogToImport.import) {
                              FirestoreService().addDogToDb(
                                dogToImport.dog,
                                null,
                                account,
                              );
                            }
                          }
                        },
                        child: const Text("Import selected dogs"),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Future<ImportDogResult?> _callGemini() async {
    final jsonSchema = GeminiSchema.schema;
    setState(() {
      isLoading = true;
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
        isLoading = false;
      });
      return null;
    }
    final bytes = platformFile!.bytes;
    if (bytes == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(errorSnackBar(context, "File bytes are empty"));
      setState(() {
        isLoading = false;
      });
      return null;
    }
    if (!["pdf", "csv"].contains(platformFile!.extension)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(errorSnackBar(context, "Unsupported file format"));
      setState(() {
        isLoading = false;
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
        isLoading = false;
      });
      return imported;
    } catch (e, s) {
      BasicLogger().error("Couldn't generate content", error: e, stackTrace: s);
      setState(() {
        isLoading = false;
      });
      return null;
    }
  }
}
