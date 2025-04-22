import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/edit_kennel/dog/dog_run_table.dart';
import 'package:mush_on/edit_kennel/dog/tags.dart';
import 'package:mush_on/services/error_handling.dart';

import '../../services/models/dog.dart';
import 'dog_run_data_chart.dart';

class DogMain extends StatelessWidget {
  final Dog dog;
  const DogMain({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DogTotal.getDogTotals(id: dog.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text(
            "ERROR: couldn't fetch data: ${snapshot.error.toString()}",
            style: TextStyle(color: Colors.red),
          );
        }
        if (snapshot.data == null) {
          return Text(
            "Couldn't fetch data",
            style: TextStyle(color: Colors.red),
          );
        }
        return ListView(
          children: [
            DogPhotoCard(dog),
            PositionsWidget(dog.positions),
            TagsWidget(dog.tags),
            DogInfoWidget(dog),
            DogRunDataWidget(snapshot.data!),
            DogrunTableWidget(snapshot.data!),
          ],
        );
      },
    );
  }
}

class DogPhotoCard extends StatelessWidget {
  final Dog dog;
  const DogPhotoCard(this.dog, {super.key});

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
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 5,
          children: [
            TextTitle("Positions"),
            IconButton.outlined(onPressed: () {}, icon: Icon(Icons.edit)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

class TagsWidget extends StatelessWidget {
  final List<Tag> tags;
  const TagsWidget(this.tags, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextTitle("Tags"),
              IconButton.outlined(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => EditTagsDialog());
                  },
                  icon: Icon(Icons.edit)),
              IconButton.outlined(
                  onPressed: () {
                    showDialog(
                        context: context, builder: (context) => AddTagDialog());
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
          Placeholder(),
        ],
      ),
    );
  }
}

class DogInfoWidget extends StatelessWidget {
  final Dog dog;
  const DogInfoWidget(this.dog, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        TextTitle("${dog.name}'s info"),
        Row(
          spacing: 5,
          children: [
            IconButton.outlined(
              onPressed: () {},
              icon: Icon(Icons.edit),
            ),
            Expanded(
              child: DogInfoRow(
                "Birthday",
                formatBirth(),
              ),
            ),
          ],
        ),
        Divider(),
        DogInfoRow("Sex", getDogSex()),
        Divider(),
        DogInfoRow("Age", dog.age != null ? dog.age! : "?"),
      ],
    );
  }

  String formatBirth() {
    if (dog.birth == null) return "?";
    return DateFormat("yyyy-MM-dd").format(dog.birth!);
  }

  String getDogSex() {
    if (dog.sex == DogSex.male) return "Male";
    if (dog.sex == DogSex.female) return "Female";
    if (dog.sex == DogSex.none) return "?";
    BasicLogger().error("Dog sex not found");
    throw Exception("Dog sex not Found. This shouldn't happen!");
  }
}

class DogInfoRow extends StatelessWidget {
  final String title;
  final String content;
  const DogInfoRow(this.title, this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18)),
        Text(content, style: TextStyle(fontSize: 18)),
      ],
    );
  }
}

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

class TextTitle extends StatelessWidget {
  final String text;
  const TextTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
    );
  }
}
