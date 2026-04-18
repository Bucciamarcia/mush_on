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

  void fromDogResults(ImportDogResult result) {
    if (!result.isSuccessful) {
      return;
    }
    List<DogToImport> toReturn = [];
    final dogsAsync = ref.read(dogsProvider);
    try {
      dogsAsync.whenData((dogs) {
        final dogNames = _createDogNamesList(dogs);
        for (final d in result.dogs) {
          toReturn.add(
            DogToImport(
              dog: Dog(id: const Uuid().v4()),
              import: !dogNames.contains(d),
              isNameDuplicate: dogNames.contains(d),
            ),
          );
        }
        state = toReturn;
      });
    } catch (e, s) {
      BasicLogger().error(
        "Error: Unable to process dog import results",
        error: e,
        stackTrace: s,
      );
    }
  }

  Set<String> _createDogNamesList(List<Dog> dogs) {
    Set<String> toReturn = {};
    for (final dog in dogs) {
      toReturn.add(dog.name);
    }
    return toReturn;
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
