import 'package:flutter/material.dart';
import 'package:mush_on/kennel/dog/dog_run_data_chart.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/shared/text_title.dart';

class DogRunDataWidget extends StatelessWidget {
  final List<DogTotal> dogTotals;
  const DogRunDataWidget(this.dogTotals, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        const TextTitle("Past runs"),
        Card(
          child: ExpansionTile(
            title: const Text("View chart"),
            children: [
              DogRunDataChart(dogTotals),
            ],
          ),
        ),
      ],
    );
  }
}
