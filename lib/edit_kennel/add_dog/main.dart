import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mush_on/edit_kennel/add_dog/add_dog_button.dart';
import 'package:mush_on/edit_kennel/add_dog/dog_name_widget.dart';
import 'package:mush_on/edit_kennel/add_dog/provider.dart';
import 'package:mush_on/edit_kennel/dog/dog_photo_card.dart';
import 'package:mush_on/edit_kennel/dog/positions_widget.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:provider/provider.dart';

class AddDogMain extends StatelessWidget {
  const AddDogMain({super.key});

  @override
  Widget build(BuildContext context) {
    BasicLogger logger = BasicLogger();
    var addDogProvider = context.watch<AddDogProvider>();
    return ListView(
      children: [
        DogNameWidget(addDogProvider: addDogProvider),
        SizedBox(height: 20),
        DogPhotoCard(
            onImageDeleted: () => addDogProvider.deleteImage(),
            onImageEdited: (File file) => addDogProvider
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
            isLoading: addDogProvider.isLoadingImage,
            image: addDogProvider.image),
        SizedBox(height: 20),
        PositionsWidget(
          positions: addDogProvider.positions,
          onPositionsChanged: (DogPositions newPositions) {
            logger.debug("New positions: ${newPositions.toString()}");
            addDogProvider.updatePositions(newPositions);
          },
        ),
        SizedBox(height: 20),
        AddDogButton(addDogProvider: addDogProvider),
      ],
    );
  }
}
