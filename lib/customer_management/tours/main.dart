import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mush_on/customer_management/tours/riverpod.dart';

import 'models.dart';

class ToursMainScreen extends ConsumerWidget {
  const ToursMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<TourType> tours = ref.watch(allTourTypesProvider).value ?? [];
    return ListView.builder(
      itemCount: tours.length,
      itemBuilder: (c, i) => TourTypeCard(tour: tours[i]),
    );
  }
}

class TourTypeCard extends StatelessWidget {
  final TourType tour;
  const TourTypeCard({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        "/tours_add",
        queryParameters: {"tourId": tour.id},
      ),
      child: Card(
        child: Column(
          children: [
            Text(tour.name),
          ],
        ),
      ),
    );
  }
}
