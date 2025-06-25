import 'package:flutter/material.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:mush_on/tasks/tab_bar_widgets/sf_schedule_view.dart';

class DogTasksWidget extends StatelessWidget {
  final Dog dog;
  const DogTasksWidget({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextTitle("Tasks"),
      ],
    );
  }
}
