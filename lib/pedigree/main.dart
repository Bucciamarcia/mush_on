import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/pedigree/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/kennel/dog/riverpod.dart';
import 'package:go_router/go_router.dart';

class PedigreeCanvas extends ConsumerStatefulWidget {
  final Dog dog;
  const PedigreeCanvas({super.key, required this.dog});

  @override
  ConsumerState<PedigreeCanvas> createState() => _PedigreeCanvasState();
}

class _PedigreeCanvasState extends ConsumerState<PedigreeCanvas> {
  final _transformationController = TransformationController();
  final _viewerKey = GlobalKey();
  final _focusKey = GlobalKey();
  bool _didCenter = false;

  void _centerOnFocus() {
    if (_didCenter) return;
    final focusContext = _focusKey.currentContext;
    final viewerContext = _viewerKey.currentContext;
    if (focusContext == null || viewerContext == null) return;

    final box = focusContext.findRenderObject() as RenderBox?;
    final viewerBox = viewerContext.findRenderObject() as RenderBox?;
    if (box == null || viewerBox == null) return;

    final childGlobal = box.localToGlobal(Offset.zero);
    final parentGlobal = viewerBox.localToGlobal(Offset.zero);
    final offsetInParent = childGlobal - parentGlobal;

    final childCenter = offsetInParent + box.size.center(Offset.zero);
    final parentCenter = viewerBox.size.center(Offset.zero);
    final delta = parentCenter - childCenter;

    _transformationController.value = Matrix4.identity()
      ..translate(delta.dx, delta.dy);
    _didCenter = true;
  }

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
    final List<Dog> sibilings = _getSiblings(widget.dog, allDogs);
    for (final sibiling in sibilings) {
      dogLayouts.add(DogLayout(dog: sibiling, rank: 0));
    }
    _processDogDown(dogsWithChildren, DogLayout(dog: widget.dog, rank: 0),
        (processedDog) {
      dogLayouts.add(processedDog);
    });
    _processDogUp(dogswithParents, DogLayout(dog: widget.dog, rank: 0),
        (processedDog) {
      dogLayouts.add(processedDog);
    });
    dogLayouts.sort((a, b) => a.rank.compareTo(b.rank));
    final byRank = <int, List<DogLayout>>{};
    for (final dl in dogLayouts) {
      (byRank[dl.rank] ??= []).add(dl);
    }
    final minRank = byRank.keys.reduce((a, b) => a < b ? a : b);
    final maxRank = byRank.keys.reduce((a, b) => a > b ? a : b);

    final rows = <Widget>[];
    for (int r = minRank; r <= maxRank; r++) {
      final rowDogs = byRank[r] ?? const [];
      if (rowDogs.isEmpty) {
        rows.add(
            const SizedBox(height: 40)); // optional spacer for empty generation
        continue;
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowDogs
              .map((lir) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleDogDisplay(
                      key: lir.dog.id == widget.dog.id ? _focusKey : null,
                      dog: lir.dog,
                      focusDog: widget.dog,
                    ),
                  ))
              .toList(),
        ),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerOnFocus());
    return Column(
      children: [
        const Text(
          "All the sibilings (including half sibilings), parents, grandparents, children, grandchildren of this dog.",
          maxLines: 5,
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: InteractiveViewer(
            key: _viewerKey,
            transformationController: _transformationController,
            boundaryMargin: const EdgeInsets.all(400),
            constrained: false,
            minScale: 0.5,
            maxScale: 3,
            child: Padding(
              padding: const EdgeInsets.all(200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: rows,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _processDogDown(
    Map<String, List<Dog>> childrenByParent,
    DogLayout dog,
    void Function(DogLayout) onDogProcessed, {
    Set<String>? visited,
  }) {
    visited ??= <String>{};
    if (!visited.add(dog.dog.id)) return;

    final kids = childrenByParent[dog.dog.id];
    if (kids == null) return;

    for (final child in kids) {
      final childLayout = DogLayout(dog: child, rank: dog.rank + 1);
      onDogProcessed(childLayout);
      _processDogDown(childrenByParent, childLayout, onDogProcessed,
          visited: visited);
    }
  }

  void _processDogUp(
    Map<String, List<Dog>> parentsOfDog,
    DogLayout dog,
    void Function(DogLayout) onDogProcessed, {
    Set<String>? visited,
  }) {
    visited ??= <String>{};
    if (!visited.add(dog.dog.id)) return;

    final parents = parentsOfDog[dog.dog.id];
    if (parents == null) return;

    for (final parent in parents) {
      final parentLayout = DogLayout(dog: parent, rank: dog.rank - 1);
      onDogProcessed(parentLayout);
      _processDogUp(parentsOfDog, parentLayout, onDogProcessed,
          visited: visited);
    }
  }

  Map<String, List<Dog>> _getChildrenOfDogs(List<Dog> allDogs) {
    final map = <String, List<Dog>>{};
    for (final d in allDogs) {
      if (d.motherId != null) (map[d.motherId!] ??= []).add(d);
      if (d.fatherId != null) (map[d.fatherId!] ??= []).add(d);
    }
    return map;
  }

  Map<String, List<Dog>> _getParentsOfDogs(List<Dog> allDogs) {
    final byId = {for (final d in allDogs) d.id: d};
    final map = <String, List<Dog>>{};
    for (final d in allDogs) {
      final parents = <Dog>[];
      if (d.fatherId != null && byId[d.fatherId!] != null) {
        parents.add(byId[d.fatherId!]!);
      }
      if (d.motherId != null && byId[d.motherId!] != null) {
        parents.add(byId[d.motherId!]!);
      }
      map[d.id] = parents;
    }
    return map;
  }

  List<Dog> _getSiblings(Dog dog, List<Dog> allDogs) {
    final targetParents = <String>{
      if (dog.fatherId != null) dog.fatherId!,
      if (dog.motherId != null) dog.motherId!,
    };
    if (targetParents.isEmpty) return [];

    final seen = <String>{};
    final out = <Dog>[];

    for (final d in allDogs) {
      if (d.id == dog.id) continue;
      final p = <String>{
        if (d.fatherId != null) d.fatherId!,
        if (d.motherId != null) d.motherId!,
      };
      if (p.isEmpty) continue;
      // share at least one parent?
      if (p.intersection(targetParents).isNotEmpty && seen.add(d.id)) {
        out.add(d);
      }
    }
    return out;
  }
}

class SingleDogDisplay extends ConsumerWidget {
  final Dog dog;
  final Dog focusDog;
  const SingleDogDisplay(
      {super.key, required this.dog, required this.focusDog});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(accountProvider);

    Widget avatar = const CircleAvatar(child: Icon(Icons.pets));
    if (accountAsync.hasValue) {
      final imgAsync =
          ref.watch(singleDogImageProvider(accountAsync.value ?? "", dog.id));
      avatar = imgAsync.when(
        data: (bytes) => CircleAvatar(
          radius: 24,
          backgroundImage: (bytes != null) ? MemoryImage(bytes) : null,
          child: (bytes == null) ? const Icon(Icons.pets) : null,
        ),
        loading: () => const CircleAvatar(child: CircularProgressIndicator()),
        error: (_, __) => const CircleAvatar(child: Icon(Icons.pets)),
      );
    }

    final sexIcon = switch (dog.sex) {
      DogSex.male => const Icon(Icons.male, size: 16),
      DogSex.female => const Icon(Icons.female, size: 16),
      _ => const SizedBox.shrink(),
    };

    final positions = dog.positions.getTrue();

    return Card(
      elevation: 2,
      color: dog.id == focusDog.id ? Colors.red[100] : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.pushNamed(
          "/dog",
          queryParameters: {"dogId": dog.id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              avatar,
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dog.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      sexIcon,
                    ],
                  ),
                  if (dog.age != null)
                    Text(
                      'Age: ${dog.age}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (positions.isNotEmpty)
                    Text(
                      'Positions: ${positions.join(", ")}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
