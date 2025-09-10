import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/mass_cg_adder/riverpod.dart';

import '../models.dart';

class DayOfWeekSelector extends ConsumerWidget {
  const DayOfWeekSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<DaysOfWeekSelection> daysOfWeekSelected =
        ref.watch(daysOfWeekSelectedProvider);
    return Column(
      spacing: 10,
      children: [
        const Text("Choose which days this rule applies to"),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: DaysOfWeekSelection.values
              .map((dayEnum) => DayEnumBubble(
                    dayEnum,
                    isActive: daysOfWeekSelected.contains(dayEnum),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class DayEnumBubble extends ConsumerWidget {
  final DaysOfWeekSelection dayEnum;
  final bool isActive;
  const DayEnumBubble(this.dayEnum, {super.key, required this.isActive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        splashFactory: InkSplash.splashFactory,
        onTap: () =>
            ref.read(daysOfWeekSelectedProvider.notifier).flipday(dayEnum),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              shape: BoxShape.circle),
          child: Center(
              child: Text(
            dayEnum.letter,
            style: const TextStyle(fontSize: 20),
          )),
        ));
  }
}
