import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/kennel/add_dog/add_dog_button.dart';
import 'package:mush_on/kennel/add_dog/dog_name_widget.dart';
import 'package:mush_on/kennel/add_dog/riverpod.dart';
import 'package:mush_on/kennel/dog/custom_field_area.dart';
import 'package:mush_on/kennel/dog/dog_info_widget.dart';
import 'package:mush_on/kennel/dog/dog_photo_card.dart';
import 'package:mush_on/kennel/dog/positions_widget.dart';
import 'package:mush_on/kennel/dog/single_dog_notes_widget.dart';
import 'package:mush_on/kennel/dog/tags_widget.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/shared/distance_warning_widget/main.dart';

class AddDogMain extends ConsumerWidget {
  const AddDogMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var logger = BasicLogger();
    AddDogData dogData = ref.watch(addDogProvider);
    var dogNotifier = ref.read(addDogProvider.notifier);
    return ListView(
      children: [
        DogNameWidget(onChanged: (name) => dogNotifier.changeName(name)),
        SizedBox(height: 20),
        DogPhotoCard(
          onImageDeleted: () => dogNotifier.changeImage(null),
          onImageEdited: (File file) => dogNotifier.changeImage(file),
          isLoading: false,
          image: dogData.file?.readAsBytesSync(),
        ),
        SizedBox(height: 20),
        PositionsWidget(
          positions: dogData.dog.positions,
          onPositionsChanged: (DogPositions newPositions) =>
              dogNotifier.changePositions(newPositions),
        ),
        SizedBox(height: 20),
        TagsWidget(
          tags: dogData.dog.tags,
          allTags: TagRepository.getAllTagsFromDogs(
              ref.watch(dogsProvider).value ?? []),
          onTagAdded: (Tag tag) async {
            dogNotifier.addTag(tag);
            logger.debug("Initiating adding a tag: ${tag.name}");
          },
          onTagChanged: (Tag tag) {
            dogNotifier.changeTag(tag);
          },
          onTagDeleted: (Tag tag) {
            dogNotifier.deleteTag(tag);
          },
        ),
        SizedBox(height: 20),
        DogInfoWidget(
          name: dogData.dog.name,
          birthday:
              (dogData.dog.birth == null) ? null : dogData.dog.birth!.toUtc(),
          sex: dogData.dog.sex,
          customFields: dogData.dog.customFields,
          onBirthdayChanged: (newBirthday) async {
            dogNotifier.changeBirthday(newBirthday);
          },
          onSexChanged: (newSex) {
            dogNotifier.changeSex(newSex);
          },
        ),
        SizedBox(height: 20),
        DistanceWarningWidget(
            warnings: dogData.dog.distanceWarnings,
            onWarningAdded: (w) => dogNotifier.addDistanceWarning(w),
            onWarningEdited: (w) {
              dogNotifier.updateWarning(w);
            },
            onWarningRemoved: (id) {
              dogNotifier.removeWarning(id);
            }),
        SizedBox(height: 20),
        CustomFieldArea(
          customFieldTemplates:
              ref.watch(settingsProvider).value?.customFieldTemplates,
          dogCustomFields: dogData.dog.customFields,
          onCustomFieldSaved: (cf) => dogNotifier.editCustomFields(cf),
          onCustomFieldDeleted: (templateId) =>
              dogNotifier.deleteCustomField(templateId),
        ),
        SizedBox(height: 20),
        SingleDogNotesWidget(
            dogNotes: dogData.dog.notes,
            onNoteAdded: (newNote) => dogNotifier.addNote(newNote),
            onNoteDeleted: (id) => dogNotifier.deleteNote(id)),
        SizedBox(height: 20),
        AddDogButton(
          dog: dogData.dog,
          imageData: dogData.file,
          onDogAdded: () => ref.invalidate(addDogProvider),
        ),
      ],
    );
  }
}
