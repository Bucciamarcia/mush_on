import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/tours/repository.dart';
import 'package:mush_on/riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models.dart';

class TourEditorMain extends ConsumerStatefulWidget {
  final TourType? tour;
  const TourEditorMain({super.key, this.tour});

  @override
  ConsumerState<TourEditorMain> createState() => _TourEditorMainState();
}

class _TourEditorMainState extends ConsumerState<TourEditorMain> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(),
          _saveRow(ref),
        ],
      ),
    );
  }

  Wrap _saveRow(WidgetRef ref) {
    return Wrap(
      spacing: 15,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            var repo = ToursRepository(
              account: await ref.watch(accountProvider.future),
            );
            await repo.setTour(TourType(id: Uuid().v4()));
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
