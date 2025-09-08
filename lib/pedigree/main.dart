import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/pedigree/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models.dart';

class PedigreeCanvas extends ConsumerStatefulWidget {
  final Dog dog;
  const PedigreeCanvas({super.key, required this.dog});

  @override
  ConsumerState<PedigreeCanvas> createState() => _PedigreeCanvasState();
}

class _PedigreeCanvasState extends ConsumerState<PedigreeCanvas> {
  @override
  Widget build(BuildContext context) {
    /// The usual list of all dogs.
    List<Dog> allDogs = ref.watch(dogsProvider).value ?? [];

    /// A map containing the string of all dogs, associated with a list of all its children.
    final dogsWithChildren = _getChildrenOfDogs(allDogs);

    /// A map containing the string of all dogs, associated with a list of its parents.
    final dogswithParents = _getParentsOfDogs(allDogs);

    /// The list of DogLayouts that include the rank.
    final List<DogLayout> dogLayouts = [];
    dogLayouts.add(DogLayout(dog: widget.dog, rank: 0));
    final List<Dog> sibilings = _getSibilings(widget.dog, allDogs);
    for (final sibiling in sibilings) {
      dogLayouts.add(DogLayout(dog: sibiling, rank: 0));
    }
    dogLayouts.sort((a, b) => a.rank.compareTo(b.rank));
    return InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(double.infinity),
        constrained: false,
        child: Column(
          children: [
            Row(
              children: dogLayouts
                  .map((dogLayout) => SingleDogDisplay(dog: dogLayout.dog))
                  .toList(),
            )
          ],
        ));
  }

  Map<String, List<Dog>> _getChildrenOfDogs(List<Dog> allDogs) {
    Map<String, List<Dog>> toReturn = {};
    for (Dog dog in allDogs) {
      Set<Dog> children = {};
      children.addAll(allDogs.where((d) {
        if (d.fatherId == dog.id || d.motherId == dog.id) return true;
        return false;
      }));
      toReturn.addAll({dog.id: children.toList()});
    }
    return toReturn;
  }

  Map<String, List<Dog>> _getParentsOfDogs(List<Dog> allDogs) {
    Map<String, List<Dog>> toReturn = {};
    for (Dog dog in allDogs) {
      List<Dog> parents = [];
      if (dog.fatherId != null) {
        final father = allDogs.getDogFromId(dog.fatherId!);
        if (father != null) {
          parents.add(father);
        }
      }
      if (dog.motherId != null) {
        final mother = allDogs.getDogFromId(dog.motherId!);
        if (mother != null) {
          parents.add(mother);
        }
      }
      toReturn.addAll({dog.id: parents});
    }
    return toReturn;
  }

  List<Dog> _getSibilings(Dog dog, List<Dog> allDogs) {
    final fatherId = dog.fatherId;
    final motherId = dog.motherId;
    if (motherId == null && fatherId == null) return [];
    List<Dog> toReturn = [];
    List<String> toCheck = [];
    if (fatherId != null) toCheck.add(fatherId);
    if (motherId != null) toCheck.add(motherId);

    for (Dog d in allDogs) {
      if (d.motherId == null && d.fatherId == null) continue;
      List<String> dParents = [];
      if (d.fatherId != null) dParents.add(d.fatherId!);
      if (d.motherId != null) dParents.add(d.motherId!);
      for (final dParent in dParents) {
        if (!toCheck.contains(dParent)) continue;
      }
      toReturn.add(d);
    }
    toReturn.removeWhere((res) => res.id == dog.id);
    return toReturn;
  }
}

class SingleDogDisplay extends StatelessWidget {
  final Dog dog;
  const SingleDogDisplay({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(dog.name),
    );
  }
}
