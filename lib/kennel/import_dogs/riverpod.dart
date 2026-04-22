import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/kennel/import_dogs/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@riverpod
class DogsToImportState extends _$DogsToImportState {
  @override
  List<DogToImport> build() {
    return [];
  }

  Future<void> fromDogResults(ImportDogResult result) async {
    if (!result.isSuccessful) {
      return;
    }

    try {
      final dogs = await ref.read(dogsProvider.future);
      final dogNames = _createDogNamesList(dogs);

      state = result.dogs
          .map(
            (name) => DogToImport(
              dog: Dog(id: const Uuid().v4(), name: name),
              import: !dogNames.contains(name),
              isNameDuplicate: _isDuplicate(dogNames, name),
            ),
          )
          .toList();
    } catch (e, s) {
      BasicLogger().error(
        "Error: Unable to process dog import results",
        error: e,
        stackTrace: s,
      );
    }
  }

  bool _isDuplicate(Set<String> dogNames, String name) {
    return dogNames.any(
      (nameInList) => nameInList.toLowerCase() == name.toLowerCase(),
    );
  }

  Set<String> _createDogNamesList(List<Dog> dogs) {
    Set<String> toReturn = {};
    for (final dog in dogs) {
      toReturn.add(dog.name);
    }
    return toReturn;
  }

  void flipDog(int i, bool v) {
    List<DogToImport> toReturn = [];
    state.asMap().forEach((key, value) {
      if (key != i) {
        toReturn.add(value);
      } else {
        toReturn.add(value.copyWith(import: v));
      }
    });
    state = toReturn;
  }
}

@freezed
sealed class DogToImport with _$DogToImport {
  const factory DogToImport({
    required Dog dog,
    required bool import,
    required bool isNameDuplicate,
  }) = _DogToImport;
}
