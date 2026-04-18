import 'package:file_picker/file_picker.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/kennel/import_dogs/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/shared/upload_document/main.dart';

class ImportDogsMain extends StatefulWidget {
  const ImportDogsMain({super.key});

  @override
  State<ImportDogsMain> createState() => _ImportDogsMainState();
}

class _ImportDogsMainState extends State<ImportDogsMain> {
  late String output;
  late bool isLoading;
  late TextEditingController pathController;
  PlatformFile? platformFile;
  @override
  void initState() {
    output = "Waiting for output";
    isLoading = false;
    pathController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: isLoading ? null : () async => await _callGemini(),
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text("test"),
          ),
          Text(output),
        ],
      ),
    );
  }

  Future<void> _callGemini() async {
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
      return;
    }
    final bytes = platformFile!.bytes;
    if (bytes == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(errorSnackBar(context, "File bytes are empty"));
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (!["pdf", "csv"].contains(platformFile!.extension)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(errorSnackBar(context, "Unsupported file format"));
      setState(() {
        isLoading = false;
      });
      return;
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
        output = imported.toString();
        isLoading = false;
      });
    } catch (e, s) {
      BasicLogger().error("Couldn't generate content", error: e, stackTrace: s);
      setState(() {
        output = "Error: $e";
        isLoading = false;
      });
    }
  }
}
