import 'package:flutter/material.dart';
import 'package:mush_on/edit_kennel/dog/main.dart';
import 'package:mush_on/services/models/dog.dart';

class PositionsWidget extends StatelessWidget {
  final DogPositions positions;
  const PositionsWidget(this.positions, {super.key});

  @override
  Widget build(BuildContext context) {
    final positionCards = positions
        .toJson()
        .entries
        .map((e) => PositionCard(e.key, e.value as bool))
        .toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            TextTitle("Positions"),
            IconButton.outlined(onPressed: () {}, icon: Icon(Icons.edit)),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: positionCards,
        ),
      ],
    );
  }
}

class PositionCard extends StatelessWidget {
  final String position;
  final bool canRun;
  const PositionCard(this.position, this.canRun, {super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Card(
        color: (canRun) ? Colors.lightGreen[300] : Colors.red[300],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                position,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 5),
              (canRun) ? Icon(Icons.check) : Icon(Icons.cancel_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
