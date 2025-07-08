import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/kennel/add_dog/add_dog_button.dart';
import 'package:mush_on/kennel/add_dog/dog_name_widget.dart';
import 'package:mush_on/kennel/add_dog/riverpod.dart';
import 'package:mush_on/kennel/dog/dog_photo_card.dart';
import 'package:mush_on/kennel/dog/positions_widget.dart';
import 'package:mush_on/services/models.dart';

class AddDogMain extends ConsumerWidget {
  const AddDogMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        AddDogButton(
          dog: dogData.dog,
          imageData: dogData.file,
          onDogAdded: () => ref.invalidate(addDogProvider),
        ),
      ],
    );
  }
}
