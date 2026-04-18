import 'package:file_picker/file_picker.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/kennel/import_dogs/models.dart';
import 'package:mush_on/kennel/import_dogs/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
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
    return SingleChildScrollView(
      child: Column(
        children: [
          UploadDocumentWidget(
            onDocumentSelected: (f) {
              setState(() {
                platformFile = f;
              });
            },
          ),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    final result = await _callGemini();
                    if (result != null) {
                      ref
                          .read(dogsToImportStateProvider.notifier)
                          .fromDogResults(result);
                    }
                  },
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text("test"),
          ),
          dogsToImport.isNotEmpty
              ? DogsToImportGrid(dogsToImport: dogsToImport)
              : const SizedBox.shrink(),
        ],
      ),
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

class DogsToImportGrid extends StatelessWidget {
  final List<DogToImport> dogsToImport;
  const DogsToImportGrid({super.key, required this.dogsToImport});

  @override
  Widget build(BuildContext context) {
    return Text(dogsToImport.toString());
  }
}
