import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod
class DogsDisplayList extends _$DogsDisplayList {
  @override
  List<Dog> build() {
    var initialDogs = ref.watch(dogsProvider).valueOrNull ?? [];
    var dogsCopy = List<Dog>.from(initialDogs);
    dogsCopy.sort((a, b) => a.name.compareTo(b.name));
    return dogsCopy;
  }

  void setDogs(List<Dog> dogs) {
    var dogsCopy = List<Dog>.from(dogs);
    dogsCopy.sort((a, b) => a.name.compareTo(b.name));
    state = dogsCopy;
  }
}
