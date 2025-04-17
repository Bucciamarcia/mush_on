import 'package:flutter/material.dart';

import '../../services/models/dog.dart';

class DogMain extends StatelessWidget {
  final Dog dog;
  const DogMain({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return Text(dog.name);
  }
}
