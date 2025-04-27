import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/edit_kennel/dog/dog_photo_card.dart';
import 'package:mush_on/edit_kennel/dog/dog_run_table.dart';
import 'package:mush_on/edit_kennel/dog/positions_widget.dart';
import 'package:mush_on/edit_kennel/dog/provider.dart';
import 'package:mush_on/edit_kennel/dog/tags_widget.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:provider/provider.dart';
import '../../services/models/dog.dart';
import 'dog_run_data_chart.dart';
import 'name_widget.dart';

class DogMain extends StatelessWidget {
  final Dog dog;
  static BasicLogger logger = BasicLogger();
  const DogMain({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    SingleDogProvider singleDogProvider = context.watch<SingleDogProvider>();
    DogProvider provider = context.watch<DogProvider>();

    return ListView(
      children: [
        NameWidget(
          name: singleDogProvider.name,
          onNameChanged: (String newName) =>
              singleDogProvider.changeName(newName).catchError((e, s) {
            logger.error("Couldn't change the name of the dog",
                error: e, stackTrace: s);
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(ErrorSnackbar("Couldn't change dog name"));
            }
          }),
        ),
        Divider(),
        DogPhotoCard(
          image: singleDogProvider.image,
          isLoading: singleDogProvider.isLoadingImage,
          onImageEdited: (File file) => singleDogProvider
              .editImage(file, provider.account)
              .catchError((e, s) {
            logger.error("Couldn't edit image", error: e, stackTrace: s);
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(ErrorSnackbar("Couldn't edit image"));
            }
          }),
          onImageDeleted: () => singleDogProvider
              .deleteImage(provider.account)
              .catchError((e, s) {
            logger.error("Couldn't remove image", error: e, stackTrace: s);
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(ErrorSnackbar("Couldn't edit image"));
            }
          }),
        ),
        PositionsWidget(
          positions: singleDogProvider.positions,
          onPositionsChanged: (DogPositions newPositions) {
            logger.debug("New positions: ${newPositions.toString()}");
            singleDogProvider
                .updatePositions(newPositions, provider.account)
                .catchError((e, s) {
              logger.error("Couldn't update dog positions",
                  error: e, stackTrace: s);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    ErrorSnackbar("Error: couldn't update positions"));
              }
            });
          },
        ),
        TagsWidget(
          tags: singleDogProvider.tags,
          onTagsChanged: (List<Tag> newTags) {
            logger.debug("Initiating change of tags: ${newTags.toString()}");
            singleDogProvider.updateTags(newTags).catchError((e, s) {
              logger.error("Couldn't update tags", error: e, stackTrace: s);
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(ErrorSnackbar("Error: couldn't update tags"));
              }
            });
          },
          onTagAdded: (Tag tag) {
            logger.debug("Initiating adding a tag: ${tag.name}");
            singleDogProvider.addTag(tag).catchError((e, s) {
              logger.error("Couldn't add tag", error: e, stackTrace: s);
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(ErrorSnackbar("Error: couldn't add tag"));
              }
            });
          },
          onTagDeleted: (Tag tag) =>
              singleDogProvider.deleteTag(tag).catchError((e, s) {
            logger.error("Couldn't delete tag: ${tag.id}",
                error: e, stackTrace: s);
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(ErrorSnackbar("Error: couldn't delete tag"));
            }
          }),
        ),
        DogInfoWidget(dog),
        singleDogProvider.isLoadingTotals
            ? CircularProgressIndicator()
            : DogRunDataWidget(singleDogProvider.runTotals),
        singleDogProvider.isLoadingTotals
            ? CircularProgressIndicator()
            : DogrunTableWidget(singleDogProvider.runTotals),
      ],
    );
  }
}

class DogInfoWidget extends StatelessWidget {
  final Dog dog;
  const DogInfoWidget(this.dog, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        TextTitle("${dog.name}'s info"),
        Row(
          spacing: 5,
          children: [
            IconButton.outlined(
              onPressed: () {},
              icon: Icon(Icons.edit),
            ),
            Expanded(
              child: DogInfoRow(
                "Birthday",
                formatBirth(),
              ),
            ),
          ],
        ),
        Divider(),
        DogInfoRow("Sex", getDogSex()),
        Divider(),
        DogInfoRow("Age", dog.age != null ? dog.age! : "?"),
      ],
    );
  }

  String formatBirth() {
    if (dog.birth == null) return "?";
    return DateFormat("yyyy-MM-dd").format(dog.birth!);
  }

  String getDogSex() {
    if (dog.sex == DogSex.male) return "Male";
    if (dog.sex == DogSex.female) return "Female";
    if (dog.sex == DogSex.none) return "?";
    BasicLogger().error("Dog sex not found");
    throw Exception("Dog sex not Found. This shouldn't happen!");
  }
}

class DogInfoRow extends StatelessWidget {
  final String title;
  final String content;
  const DogInfoRow(this.title, this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18)),
        Text(content, style: TextStyle(fontSize: 18)),
      ],
    );
  }
}

class DogRunDataWidget extends StatelessWidget {
  final List<DogTotal> dogTotals;
  const DogRunDataWidget(this.dogTotals, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        TextTitle("Past runs"),
        Card(
          child: ExpansionTile(
            title: Text("View chart"),
            children: [
              DogRunDataChart(dogTotals),
            ],
          ),
        ),
      ],
    );
  }
}

class TextTitle extends StatelessWidget {
  final String text;
  const TextTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
    );
  }
}
