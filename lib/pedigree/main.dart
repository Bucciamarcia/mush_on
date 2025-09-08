import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models.dart';

class PedigreeCanvas extends ConsumerStatefulWidget {
  const PedigreeCanvas({super.key});

  @override
  ConsumerState<PedigreeCanvas> createState() => _PedigreeCanvasState();
}

class _PedigreeCanvasState extends ConsumerState<PedigreeCanvas> {
  @override
  Widget build(BuildContext context) {
    final List<Dog> allDogs = ref.watch(dogsProvider).value ?? [];

    /// Dogs with no known parents.
    final List<Dog> rootDogs = _getRootDogs(allDogs);

    /// Map of dog id -> all its children.
    final childrenByParent = _getChildrenByParent(allDogs);

    /// Map of dog id -> its parents.
    final parentsOfDogs = _getParentsOfDogs(allDogs);

    /// Map of dogs by id for faster lookup.
    final byId = {for (final d in allDogs) d.id: d};
    return InteractiveViewer(
        constrained: false,
        scaleEnabled: true,
        panEnabled: true,
        minScale: 0.25,
        maxScale: 4,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        child: Wrap(
          children: allDogs.map((dog) => SingleDogCard(dog: dog)).toList(),
        ));
  }

  List<Dog> _getRootDogs(List<Dog> allDogs) {
    List<Dog> toReturn = [];
    for (final dog in allDogs) {
      if (dog.motherId == null && dog.fatherId == null) {
        toReturn.add(dog);
      }
    }
    return toReturn;
  }

  Map<String, List<Dog>> _getChildrenByParent(List<Dog> all) {
    final map = <String, List<Dog>>{};
    for (final d in all) {
      if (d.motherId != null) (map[d.motherId!] ??= []).add(d);
      if (d.fatherId != null) (map[d.fatherId!] ??= []).add(d);
    }
    return map;
  }

  Map<String, List<Dog>> _getParentsOfDogs(List<Dog> allDogs) {
    final byId = {for (final d in allDogs) d.id: d};
    final map = <String, List<Dog>>{};
    for (final dog in allDogs) {
      final parents = <Dog>[];
      if (dog.fatherId != null) {
        final f = byId[dog.fatherId!];
        if (f != null) parents.add(f);
      }
      if (dog.motherId != null) {
        final m = byId[dog.motherId!];
        if (m != null) parents.add(m);
      }
      map[dog.id] = parents;
    }
    return map;
  }

  List<Dog> _getChildrenTwoDogs(
    Dog a,
    Dog b,
    Map<String, List<Dog>> childrenByParent,
  ) {
    if (a.id == b.id) return const [];

    final aKids = childrenByParent[a.id] ?? const [];
    final bKidIds = {
      for (final d in (childrenByParent[b.id] ?? const [])) d.id
    };

    return [
      for (final d in aKids)
        if (bKidIds.contains(d.id)) d,
    ];
  }

  Set<String> _parentIdsOf(Dog d) {
    final s = <String>{};
    if (d.motherId != null) s.add(d.motherId!);
    if (d.fatherId != null) s.add(d.fatherId!);
    return s;
  }

  List<Dog> _getMates(
      Dog dog, List<Dog> allDogs, Map<String, List<Dog>> childrenByParent) {
    final mates = <String>{};

    final byId = {for (final d in allDogs) d.id: d};
    for (final child in childrenByParent[dog.id] ?? const []) {
      for (final pid in _parentIdsOf(child)) {
        if (pid != dog.id) mates.add(pid);
      }
    }

    return [
      for (final id in mates)
        if (byId.containsKey(id)) byId[id]!,
    ];
  }
}

class SingleDogCard extends StatelessWidget {
  final Dog dog;
  const SingleDogCard({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(dog.name),
    );
  }
}
