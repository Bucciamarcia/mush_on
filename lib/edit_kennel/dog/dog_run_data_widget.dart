import 'package:flutter/material.dart';
import 'package:mush_on/edit_kennel/dog/dog_run_data_chart.dart';
import 'package:mush_on/edit_kennel/dog/main.dart';
import 'package:mush_on/edit_kennel/dog/text_title.dart';
import 'package:mush_on/services/models/dog.dart';

class DogRunDataWidget extends StatelessWidget {
  final List<DogTotal> dogTotals;
  const DogRunDataWidget(this.dogTotals, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        TextTitle("Past runs"),
        Card(
          child: ExpansionTile(
            title: Text("View chart"),
            children: [
              DogRunDataChart(dogTotals),
            ],
          ),
        ),
      ],
    );
  }
}
