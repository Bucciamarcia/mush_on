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
    tours.sort((a, b) => a.distance.compareTo(b.distance));
    final colorScheme = Theme.of(context).colorScheme;

    if (tours.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.tour,
              size: 64,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              "No Tours Available",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Create your first tour to get started",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tours.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (c, i) => TourTypeCard(tour: tours[i]),
    );
  }
}

class TourTypeCard extends ConsumerWidget {
  final TourType tour;
  const TourTypeCard({super.key, required this.tour});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final prices = ref.watch(tourTypePricesProvider(tour.id)).value ?? [];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => context.pushNamed(
          "/tours_add",
          queryParameters: {"tourId": tour.id},
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              _buildHeader(colorScheme),
              if (tour.displayDescription?.isNotEmpty == true)
                _buildDescription(colorScheme),
              _buildDetailsRow(colorScheme),
              if (prices.isNotEmpty) _buildPricingInfo(colorScheme, prices),
              if (tour.notes?.isNotEmpty == true)
                _buildInternalNotes(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.tour,
            color: colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tour.displayName.isNotEmpty ? tour.displayName : tour.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              if (tour.displayName.isNotEmpty && tour.name.isNotEmpty)
                Text(
                  tour.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.description,
            size: 16,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tour.displayDescription!,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow(ColorScheme colorScheme) {
    if (tour.distance <= 0) return const SizedBox.shrink();

    return _buildDetailChip(
      icon: Icons.straighten,
      label:
          "${tour.distance.toStringAsFixed(tour.distance % 1 == 0 ? 0 : 1)} km",
      colorScheme: colorScheme,
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
    bool isPrimary = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isPrimary
            ? colorScheme.primary.withValues(alpha: 0.1)
            : colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: isPrimary
            ? Border.all(color: colorScheme.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color:
                isPrimary ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isPrimary ? FontWeight.w500 : FontWeight.w400,
              color: isPrimary
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingInfo(
      ColorScheme colorScheme, List<TourTypePricing> prices) {
    // Show price range if multiple prices, or single price if only one
    if (prices.isEmpty) return const SizedBox.shrink();

    final sortedPrices = prices.toList()
      ..sort((a, b) => a.price.compareTo(b.price));
    final minPrice = sortedPrices.first.price;
    final maxPrice = sortedPrices.last.price;

    String priceText;
    if (minPrice == maxPrice) {
      priceText = "€${minPrice.toStringAsFixed(0)}";
    } else {
      priceText =
          "€${minPrice.toStringAsFixed(0)} - €${maxPrice.toStringAsFixed(0)}";
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.euro,
            size: 18,
            color: colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  priceText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.secondary,
                  ),
                ),
                if (prices.length > 1)
                  Text(
                    "${prices.length} pricing options available",
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInternalNotes(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.sticky_note_2,
            size: 16,
            color: colorScheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Internal Notes",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tour.notes!,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
