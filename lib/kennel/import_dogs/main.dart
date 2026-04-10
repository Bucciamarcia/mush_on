import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';

class ImportDogsMain extends StatefulWidget {
  const ImportDogsMain({super.key});

  @override
  State<ImportDogsMain> createState() => _ImportDogsMainState();
}

class _ImportDogsMainState extends State<ImportDogsMain> {
  late String output;
  late bool isLoading;
  @override
  void initState() {
    output = "Waiting for output";
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(output),
        ElevatedButton(
          onPressed: isLoading ? null : () async => await _callGemini(),
          child: isLoading
              ? const CircularProgressIndicator()
              : const Text("test"),
        ),
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
    final prompt = [
      Content.text(
        "This is a test. Write that this is a success in a funny way",
      ),
    ];
    final response = await model.generateContent(prompt);
    setState(() {
      output = response.text ?? "ERROR: no text";
      isLoading = false;
    });
  }
}
