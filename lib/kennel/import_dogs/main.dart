import 'package:file_picker/file_picker.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';

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
    return Column(
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
    );
  }

  Future<void> _callGemini() async {
    setState(() {
      isLoading = true;
    });
    final model = FirebaseAI.googleAI().generativeModel(
      model: "gemini-3-flash-preview",
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
    const prompt = TextPart("Briefly summarize the content of the file");
    final response = await model.generateContent([
      Content.multi([prompt, docPart]),
    ]);
    setState(() {
      output = response.text ?? "ERROR: no text";
      isLoading = false;
    });
  }
}
