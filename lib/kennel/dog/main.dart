import 'dart:io';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models/notes.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/kennel/dog/custom_field_area.dart';
import 'package:mush_on/kennel/dog/delete_dog_button.dart';
import 'package:mush_on/kennel/dog/dog_info_widget.dart';
import 'package:mush_on/kennel/dog/dog_photo_card.dart';
import 'package:mush_on/kennel/dog/dog_run_data_widget.dart';
import 'package:mush_on/kennel/dog/dog_run_table.dart';
import 'package:mush_on/kennel/dog/dog_tasks_widget.dart';
import 'package:mush_on/kennel/dog/positions_widget.dart';
import 'package:mush_on/kennel/dog/riverpod.dart';
import 'package:mush_on/kennel/dog/single_dog_notes_widget.dart';
import 'package:mush_on/kennel/dog/tags_widget.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/shared/distance_warning_widget/main.dart';
import 'package:mush_on/shared/text_title.dart';
import '../../services/models/dog.dart';
import 'name_widget.dart';

class DogMain extends ConsumerWidget {
  final String dogId;
  static BasicLogger logger = BasicLogger();
  const DogMain({super.key, required this.dogId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dogAsync = ref.watch(singleDogProvider(dogId));
    return dogAsync.when(
        data: (dog) {
          var accountAsync = ref.watch(accountProvider);
          return accountAsync.when(
              data: (account) {
                return ListView(
                  children: [
                    NameWidget(
                        name: dog.name,
                        onNameChanged: (String newName) async {
                          try {
                            await DogsDbOperations().changeDogName(
                                id: dog.id, newName: newName, account: account);
                            // Optionally show success message
                          } catch (e, s) {
                            logger.error("Couldn't change the name of the dog",
                                error: e, stackTrace: s);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar(
                                      context, "Couldn't change dog name"));
                            }
                          }
                        }),
                    Divider(),
                    ref.watch(singleDogImageProvider(account, dog.id)).when(
                        data: (data) {
                          return DogPhotoCard(
                            image: data,
                            isLoading: false,
                            onImageEdited: (File file) => ref
                                .read(singleDogImageProvider(account, dog.id)
                                    .notifier)
                                .editImage(file: file),
                            onImageDeleted: () => ref
                                .read(singleDogImageProvider(account, dog.id)
                                    .notifier)
                                .deleteImage(),
                          );
                        },
                        error: (e, s) {
                          logger.error("Can't load image",
                              error: e, stackTrace: s);
                          return Text("Couldn't load image");
                        },
                        loading: () => CircularProgressIndicator.adaptive()),
                    PositionsWidget(
                      positions: dog.positions,
                      onPositionsChanged: (DogPositions newPositions) async {
                        try {
                          await DogsDbOperations().updateDogPositions(
                              newPositions: newPositions,
                              id: dog.id,
                              account: account);
                        } catch (e, s) {
                          logger.error("Couldn't update dog positions",
                              error: e, stackTrace: s);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(
                                    context, "Coulnd't update dog positions"));
                          }
                        }
                      },
                    ),
                    TagsWidget(
                      tags: dog.tags,
                      allTags: TagRepository.getAllTagsFromDogs(
                          ref.watch(dogsProvider).value ?? []),
                      onTagAdded: (Tag tag) async {
                        logger.debug("Initiating adding a tag: ${tag.name}");
                        try {
                          await DogsDbOperations()
                              .addTag(tag: tag, id: dog.id, account: account);
                        } catch (e, s) {
                          logger.error("Couldn't add tag",
                              error: e, stackTrace: s);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(context, "Couldn't add tag"));
                          }
                        }
                      },
                      onTagChanged: (Tag tag) {
                        try {
                          DogsDbOperations()
                              .editTag(tag: tag, id: dog.id, account: account);
                        } catch (e, s) {
                          logger.error("Couldn't edit tag",
                              error: e, stackTrace: s);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(context, "Couldn't edit tag"));
                          }
                        }
                      },
                      onTagDeleted: (Tag tag) {
                        try {
                          DogsDbOperations().deleteTag(
                              tag: tag, id: dog.id, account: account);
                        } catch (e, s) {
                          logger.error("Couldn't delete tag",
                              error: e, stackTrace: s);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(context, "Couldn't delete tag"));
                          }
                        }
                      },
                    ),
                    DogInfoWidget(
                      name: dog.name,
                      birthday: (dog.birth == null) ? null : dog.birth!.toUtc(),
                      sex: dog.sex,
                      customFields: dog.customFields,
                      onBirthdayChanged: (DateTime newBirthday) async {
                        try {
                          await DogsDbOperations().changeBirthday(
                              birthday: newBirthday,
                              id: dog.id,
                              account: account);
                        } catch (e, s) {
                          logger.error("Couldn't change birthday",
                              error: e, stackTrace: s);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(
                                    context, "Couldn't change birthday"));
                          }
                        }
                      },
                      onSexChanged: (DogSex newSex) {
                        try {
                          DogsDbOperations().changeSex(
                              sex: newSex, id: dog.id, account: account);
                        } catch (e, s) {
                          logger.error("Couldn't change sex",
                              error: e, stackTrace: s);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(context, "Couldn't change sex"));
                          }
                        }
                      },
                    ),
                    Divider(),
                    DogTasksWidget(
                      tasksInMemory: ref.watch(tasksProvider(null)).value ??
                          TasksInMemory(),
                      dog: dog,
                      onTaskEdited: (t) async {
                        try {
                          await TaskRepository.addOrUpdate(t, account);
                          if (t.isDone &&
                              t.expiration != null &&
                              t.recurring != RecurringType.none) {
                            // Create new task for next occurrence
                            Task nextOccurrence = t.copyWith(
                              id: '', // Let the repository generate a new ID
                              isDone:
                                  false, // Next occurrence starts as not done
                              expiration: t.expiration!.add(
                                (Duration(days: t.recurring.interval)),
                              ),
                            );
                            TaskRepository.addOrUpdate(
                              nextOccurrence,
                              await ref.watch(accountProvider.future),
                            );
                          }

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              confirmationSnackbar(context, "Task edited"),
                            );
                          }
                        } catch (e, s) {
                          logger.error("Couldn't edit task in dog page.",
                              error: e, stackTrace: s);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(context, "Couldn't edit task"));
                          }
                        }
                      },
                      onTaskDeleted: (t) async {
                        try {
                          await TaskRepository.delete(t, account);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              confirmationSnackbar(context, "Task deleted"),
                            );
                          }
                        } catch (e, s) {
                          logger.error("Couldn't delete task in dog page.",
                              error: e, stackTrace: s);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(context, "Couldn't delete task"));
                          }
                        }
                      },
                    ),
                    Divider(),
                    TextTitle("Custom distance warnings"),
                    DistanceWarningWidget(
                        warnings: dog.distanceWarnings,
                        onWarningAdded: (w) {
                          var newW =
                              List<DistanceWarning>.from(dog.distanceWarnings);
                          newW = [...newW, w];
                          DogsDbOperations().updateDistanceWarnings(
                              warnings: newW, dogId: dogId);
                        },
                        onWarningEdited: (w) {
                          var newW =
                              List<DistanceWarning>.from(dog.distanceWarnings);
                          newW.removeWhere((oldW) => oldW.id == w.id);
                          newW = [...newW, w];
                          DogsDbOperations().updateDistanceWarnings(
                              warnings: newW, dogId: dogId);
                        },
                        onWarningRemoved: (id) {
                          var newW =
                              List<DistanceWarning>.from(dog.distanceWarnings);
                          newW.removeWhere((oldW) => oldW.id == id);
                          DogsDbOperations().updateDistanceWarnings(
                              warnings: newW, dogId: dogId);
                        }),
                    Divider(),
                    CustomFieldArea(
                      customFieldTemplates: ref
                          .watch(settingsProvider)
                          .value
                          ?.customFieldTemplates,
                      dogCustomFields: dog.customFields,
                      onCustomFieldSaved: (r) {
                        try {
                          List<CustomField> updatedCf = [];
                          for (CustomField cf in dog.customFields) {
                            updatedCf.add(cf);
                          }
                          updatedCf
                              .removeWhere((t) => t.templateId == r.templateId);
                          updatedCf.add(r);
                          DogsDbOperations().updateCustomFields(
                              dogId: dogId, customFields: updatedCf);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Custom field  added",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          );
                        } catch (e, s) {
                          logger.error("Couldn't add the custom field",
                              error: e, stackTrace: s);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(context,
                                    "Error: couldn't add custom field"));
                          }
                        }
                      },
                      onCustomFieldDeleted: (templateId) {
                        try {
                          List<CustomField> updatedCf = [];
                          for (CustomField cf in dog.customFields) {
                            updatedCf.add(cf);
                          }
                          updatedCf
                              .removeWhere((t) => t.templateId == templateId);
                          DogsDbOperations().updateCustomFields(
                              dogId: dogId, customFields: updatedCf);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Custom field deleted",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          );
                        } catch (e, s) {
                          logger.error("Couldn't delete the custom field",
                              error: e, stackTrace: s);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar(context,
                                    "Error: couldn't delete custom field"));
                          }
                        }
                      },
                    ),
                    Divider(),
                    DogRunDataWidget(ref
                            .watch(
                                dogTotalProvider(dogId: dog.id, cutoff: null))
                            .value ??
                        []),
                    DogrunTableWidget(ref
                            .watch(
                                dogTotalProvider(dogId: dog.id, cutoff: null))
                            .value ??
                        []),
                    Divider(),
                    SingleDogNotesWidget(
                        dogNotes: dog.notes,
                        onNoteAdded: (newNote) async {
                          try {
                            List<SingleDogNote> updatedNotes = [];
                            for (SingleDogNote note in dog.notes) {
                              updatedNotes.add(note);
                            }
                            updatedNotes
                                .removeWhere((note) => note.id == newNote.id);
                            updatedNotes.add(newNote);
                            await DogsDbOperations().updateNotes(
                                dogId: dog.id, notes: updatedNotes);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  content: Text(
                                    "Note saved correctly",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ),
                              );
                            }
                          } catch (e, s) {
                            logger.error("Couldn't save note",
                                error: e, stackTrace: s);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar(
                                      context, "Error: couldn't save note"));
                            }
                          }
                        },
                        onNoteDeleted: (id) async {
                          try {
                            List<SingleDogNote> updatedNotes = [];
                            for (SingleDogNote note in dog.notes) {
                              updatedNotes.add(note);
                            }
                            updatedNotes.removeWhere((note) => note.id == id);
                            await DogsDbOperations().updateNotes(
                                dogId: dog.id, notes: updatedNotes);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  content: Text(
                                    "Note deleted correctly",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ),
                              );
                            }
                          } catch (e, s) {
                            logger.error("Couldn't delete note",
                                error: e, stackTrace: s);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar(
                                      context, "Error: couldn't delete note"));
                            }
                          }
                        }),
                    Divider(),
                    DeleteDogButton(
                      dog: dog,
                      onDogDeleted: () async {
                        await showDialog(
                          context: context,
                          builder: (dialogContext) =>
                              DeleteDogConfirmationDialog(
                            dog: dog,
                            onConfirmed: () async {
                              try {
                                await DogsDbOperations()
                                    .deleteDog(dog.id, account);
                                // First pop the dialog
                                if (dialogContext.mounted) {
                                  Navigator.of(dialogContext).pop();
                                }
                                // Then pop the original page using the original context
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Dog deleted",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ));
                                  Navigator.of(context).pop();
                                }
                              } catch (e, s) {
                                logger.error("Couldn't delete dog ${dog.name}",
                                    error: e, stackTrace: s);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      errorSnackBar(context,
                                          "Error: couldn't delete dog"));
                                }
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
              error: (e, s) {
                logger.error("Couldn't fetch account", error: e, stackTrace: s);
                return Text("Couldn't fetch account");
              },
              loading: () => CircularProgressIndicator.adaptive());
        },
        error: (e, s) {
          logger.error("Couldn't load single dog", error: e, stackTrace: s);
          return Text("Couldn't load dog: error");
        },
        loading: () => CircularProgressIndicator.adaptive());
  }
}

class DeleteDogConfirmationDialog extends StatelessWidget {
  final Dog dog;
  final Function() onConfirmed;
  const DeleteDogConfirmationDialog(
      {super.key, required this.dog, required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text("Delete"),
      content: Text(
          "Are you sure you want to delete ${dog.name}? The action is irreversible, all data will be lost."),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")),
        TextButton(
          style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(Theme.of(context).colorScheme.error),
          ),
          onPressed: () {
            onConfirmed();
            Navigator.of(context).pop();
          },
          child: Text(
            "Delete dog",
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
        ),
      ],
    );
  }
}
