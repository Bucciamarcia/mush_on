import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'tags.g.dart';

@riverpod
Stream<List<Dog>> dogsWithBlockingTags(Ref ref) async* {
  List<Dog> dogs = await ref.watch(dogsProvider.future);
  List<Dog> toReturn = [];
  for (Dog dog in dogs) {
    for (Tag tag in dog.tags) {
      if (tag.preventFromRun) {
        if (tag.expired == null) {
          toReturn.add(dog);
          break;
        }
        if (tag.expired!.isAfter(DateTimeUtils.today())) {
          toReturn.add(dog);
        }
      }
    }
  }
  yield toReturn;
}
