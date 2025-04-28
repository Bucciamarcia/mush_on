import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/edit_kennel/dog/main.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';

class DogInfoWidget extends StatelessWidget {
  static final BasicLogger logger = BasicLogger();
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
        Row(
          spacing: 5,
          children: [
            IconButton.outlined(
              onPressed: () {},
              icon: Icon(Icons.edit),
            ),
            Expanded(child: DogInfoRow("Sex", getDogSex())),
          ],
        ),
        Divider(),
        Row(
          spacing: 5,
          children: [
            IconButton.outlined(
              onPressed: () {},
              icon: Icon(Icons.edit),
            ),
            Expanded(
                child: DogInfoRow("Age", dog.age != null ? dog.age! : "?")),
          ],
        ),
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
