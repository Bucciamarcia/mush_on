import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';

class UploadDocumentWidget extends StatefulWidget {
  final Function(PlatformFile) onDocumentSelected;
  const UploadDocumentWidget({super.key, required this.onDocumentSelected});

  @override
  State<UploadDocumentWidget> createState() => _UploadDocumentWidgetState();
}

class _UploadDocumentWidgetState extends State<UploadDocumentWidget> {
  late String output;
  late bool isLoading;
  late TextEditingController pathController;
  @override
  void initState() {
    output = "Waiting for output";
    isLoading = false;
    pathController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
              widget.onDocumentSelected(file);
              setState(() {
                pathController.text = file.name;
                isLoading = false;
              });
            } catch (e, s) {
              BasicLogger().error("File pick error", error: e, stackTrace: s);
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
    );
  }
}
