import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/error_handling.dart';
part 'main.freezed.dart';
part 'main.g.dart';

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
          Row(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: TextField(controller: pathController, enabled: false),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() => isLoading = true);

                  try {
                    final result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ["pdf", "csv"],
                      withData: true,
                    );

                    if (!mounted) return;

                    if (result == null) {
                      setState(() {
                        pathController.text = "";
                        isLoading = false;
                      });
                      return;
                    }

                    final file = result.files.first;

                    if (file.bytes == null) {
                      throw Exception("File data could not be read.");
                    }

                    setState(() {
                      pathController.text = file.name;
                      platformFile = file;
                      isLoading = false;
                    });
                  } catch (e, s) {
                    BasicLogger().error(
                      "File pick error",
                      error: e,
                      stackTrace: s,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        errorSnackBar(context, "Error: ${e.toString()}"),
                      );
                    }
                    setState(() => isLoading = false);
                  }
                },
                child: const Text("Upload document"),
              ),
            ],
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
    final jsonSchema = Schema.object(
      properties: {
        "dogs": Schema.array(
          items: Schema.string(
            title:
                "The name of the dog, always first letter capitalized, eg `Fido`",
          ),
        ),
        "isSuccessful": Schema.boolean(
          title: "Whether the operation is successful",
          description:
              "True if a list of dogs can be extracted. False if it can't be extracted or the document doesn't contain a list of dogs",
        ),
      },
    );
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

@freezed
sealed class ImportDogResult with _$ImportDogResult {
  const factory ImportDogResult({
    required List<String> dogs,
    required bool isSuccessful,
  }) = _ImportDogResult;
  factory ImportDogResult.fromJson(Map<String, dynamic> json) =>
      _$ImportDogResultFromJson(json);
  const ImportDogResult._();
  int get length => dogs.length;

  static ImportDogResult decode(String source) {
    return ImportDogResult.fromJson(jsonDecode(source));
  }
}
