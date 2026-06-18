import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/kennel/dog/delete_dog_button.dart';
import 'package:mush_on/services/models/dog.dart';

void main() {
  testWidgets('active dogs can only be retired', (tester) async {
    await tester.pumpWidget(
      _harness(
        dog: const Dog(id: 'dog-1', name: 'Active'),
        onDogDeleted: () {},
        onDogRetired: () {},
        onDogUnretired: () {},
      ),
    );

    expect(find.text('Retire dog'), findsOneWidget);
    expect(find.text('Unretire dog'), findsNothing);
    expect(find.text('Delete dog'), findsNothing);
  });

  testWidgets('retired dogs can be unretired or deleted', (tester) async {
    await tester.pumpWidget(
      _harness(
        dog: const Dog(id: 'dog-1', name: 'Retired', isRetired: true),
        onDogDeleted: () {},
        onDogRetired: () {},
        onDogUnretired: () {},
      ),
    );

    expect(find.text('Retire dog'), findsNothing);
    expect(find.text('Unretire dog'), findsOneWidget);
    expect(find.text('Delete dog'), findsOneWidget);
  });
}

Widget _harness({
  required Dog dog,
  required VoidCallback onDogDeleted,
  required VoidCallback onDogRetired,
  required VoidCallback onDogUnretired,
}) {
  return MaterialApp(
    home: Scaffold(
      body: DeleteDogButton(
        dog: dog,
        onDogDeleted: onDogDeleted,
        onDogRetired: onDogRetired,
        onDogUnretired: onDogUnretired,
      ),
    ),
  );
}
