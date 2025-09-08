import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mush_on/pedigree/pedigree.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/shared/text_title.dart';

class PedigreeInfo extends ConsumerStatefulWidget {
  final Dog dog;
  const PedigreeInfo({super.key, required this.dog});

  @override
  ConsumerState<PedigreeInfo> createState() => _PedigreeinfoState();
}

class _PedigreeinfoState extends ConsumerState<PedigreeInfo> {
  final logger = BasicLogger();
  late TextEditingController motherController;
  late TextEditingController fatherController;
  @override
  void initState() {
    super.initState();
    motherController = TextEditingController();
    fatherController = TextEditingController();
  }

  @override
  void dispose() {
    motherController.dispose();
    fatherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allDogsAsync = ref.watch(dogsProvider);
    String account = ref.watch(accountProvider).value ?? "";
    return allDogsAsync.when(
        data: (allDogs) {
          return Column(
            children: [
              const TextTitle("Pedigree info"),
              Row(
                children: [
                  DropdownMenu(
                      initialSelection:
                          allDogs.getDogFromId(widget.dog.motherId ?? ""),
                      label: const Text("Mother"),
                      controller: motherController,
                      onSelected: (mother) async {
                        if (mother != null) {
                          motherController.text = mother.name;
                          await DogsDbOperations().updateMotherId(
                              motherId: mother.id,
                              id: widget.dog.id,
                              account: account);
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              confirmationSnackbar(
                                  context, "Dog mother updated"));
                        }
                      },
                      dropdownMenuEntries: allDogs
                          .where((d) => d.sex != DogSex.male)
                          .where((d) => d.id != widget.dog.id)
                          .map(
                              (d) => DropdownMenuEntry(value: d, label: d.name))
                          .toList()),
                  DropdownMenu(
                      initialSelection:
                          allDogs.getDogFromId(widget.dog.fatherId ?? ""),
                      label: const Text("Father"),
                      controller: fatherController,
                      onSelected: (father) async {
                        if (father != null) {
                          fatherController.text = father.name;
                          await DogsDbOperations().updateFatherId(
                              fatherId: father.id,
                              id: widget.dog.id,
                              account: account);
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              confirmationSnackbar(
                                  context, "Dog father updated"));
                        }
                      },
                      dropdownMenuEntries: allDogs
                          .where((d) => d.sex != DogSex.female)
                          .where((d) => d.id != widget.dog.id)
                          .map(
                              (d) => DropdownMenuEntry(value: d, label: d.name))
                          .toList()),
                ],
              ),
              ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PedigreeScreen(dog: widget.dog))),
                  label: const Text("View pedigree chart"),
                  icon: const FaIcon(FontAwesomeIcons.dog)),
            ],
          );
        },
        error: (e, s) {
          logger.error("Couldn't load dogs in pedigree info",
              error: e, stackTrace: s);
          return const Text("Error: couldn't load dogs");
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}
