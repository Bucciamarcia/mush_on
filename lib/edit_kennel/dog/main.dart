import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mush_on/edit_kennel/dog/delete_dog_button.dart';
import 'package:mush_on/edit_kennel/dog/dog_info_widget.dart';
import 'package:mush_on/edit_kennel/dog/dog_photo_card.dart';
import 'package:mush_on/edit_kennel/dog/dog_run_data_widget.dart';
import 'package:mush_on/edit_kennel/dog/dog_run_table.dart';
import 'package:mush_on/edit_kennel/dog/positions_widget.dart';
import 'package:mush_on/edit_kennel/dog/provider.dart';
import 'package:mush_on/edit_kennel/dog/tags_widget.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:provider/provider.dart';
import '../../services/models/dog.dart';
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
              .editImage(
            file,
          )
              .catchError((e, s) {
            logger.error("Couldn't edit image", error: e, stackTrace: s);
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(ErrorSnackbar("Couldn't edit image"));
            }
          }),
          onImageDeleted: () =>
              singleDogProvider.deleteImage().catchError((e, s) {
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
            singleDogProvider.updatePositions(newPositions).catchError((e, s) {
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
          allTags: TagRepository.getAllTagsFromDogs(provider.dogs),
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
          onTagChanged: (Tag tag) {
            logger.debug(
                "Initiating change tag. Color: ${tag.color.toString()} - Name: ${tag.name}");
            singleDogProvider.editTag(tag).catchError((e, s) {
              logger.error("Couldn't edit tag ${tag.name}",
                  error: e, stackTrace: s);
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(ErrorSnackbar("Error: couldn't udpate tag"));
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
        DogInfoWidget(
          name: singleDogProvider.name,
          birthday: (singleDogProvider.birth == null)
              ? null
              : singleDogProvider.birth!.toUtc(),
          sex: singleDogProvider.sex,
          customFields: singleDogProvider.customFields,
          onBirthdayChanged: (DateTime newBirthday) {
            singleDogProvider.changeBirthday(newBirthday).catchError((e, s) {
              logger.error("Couldn't change birthday for ${dog.name}",
                  error: e, stackTrace: s);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    ErrorSnackbar("Error: couldn't change dog birthday"));
              }
            });
          },
          onSexChanged: (DogSex newSex) {
            singleDogProvider.changeSex(newSex).catchError((e, s) {
              logger.error("Couldn't change sex for ${dog.name}",
                  error: e, stackTrace: s);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    ErrorSnackbar("Error: couldn't change dog sex"));
              }
            });
          },
        ),
        singleDogProvider.isLoadingTotals
            ? CircularProgressIndicator()
            : DogRunDataWidget(singleDogProvider.runTotals),
        singleDogProvider.isLoadingTotals
            ? CircularProgressIndicator()
            : DogrunTableWidget(singleDogProvider.runTotals),
        DeleteDogButton(
            dog: dog,
            onDogDeleted: () {
              singleDogProvider
                  .deleteDog()
                  .then((_) => {
                        if (context.mounted)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Dog deleted"),
                              backgroundColor: Colors.green,
                            )),
                            Navigator.of(context).pop(),
                          }
                      })
                  // ignore: body_might_complete_normally_catch_error
                  .catchError((e, s) {
                logger.error("Couldn't delete dog ${dog.name}",
                    error: e, stackTrace: s);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      ErrorSnackbar("Error: couldn't delete dog"));
                }
              });
            }),
      ],
    );
  }
}
