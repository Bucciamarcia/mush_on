import 'package:flutter/material.dart';

import '../../services/models/dog.dart';

class DogMain extends StatelessWidget {
  final Dog dog;
  const DogMain({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DogPhotoCard(dog: dog),
        Divider(),
        PositionsWidget(dog: dog),
      ],
    );
  }
}

class DogPhotoCard extends StatelessWidget {
  final Dog dog;
  const DogPhotoCard({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          Placeholder(fallbackHeight: 200),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {}, child: Text("Change picture")),
              ElevatedButton(onPressed: () {}, child: Text("Remove picture")),
            ],
          ),
        ],
      ),
    );
  }
}

class PositionsWidget extends StatelessWidget {
  final Dog dog;
  const PositionsWidget({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> positions = dog.positions.toJson();
    List<PositionCard> positionCards = [];
    positions.forEach((String position, dynamic canRun) =>
        positionCards.add(PositionCard(position, canRun as bool)));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: positionCards,
    );
  }
}

class PositionCard extends StatelessWidget {
  final String position;
  final bool canRun;
  const PositionCard(this.position, this.canRun, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
