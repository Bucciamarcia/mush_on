import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/shared/dog_filter/main.dart';
import 'package:mush_on/shared/dog_filter/provider.dart';
import 'package:provider/provider.dart';
import '../fake_dogs.dart';

void main() {
  testWidgets(
    "Test the loading of the filter widget",
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => DogFilterProvider(),
            child: DogFilterWidget(
              dogs: fakeDogs,
              onResult: (dogs) {},
            ),
          ),
        ),
      );
    },
  );
}
