import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/shared/dog_filter/enums.dart';
import 'package:mush_on/shared/dog_filter/filter_operations.dart';
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
      await tester.pumpAndSettle();
      Finder dropdownFinder = find.byKey(Key("Select condition"));
      expect(dropdownFinder, findsOne);
    },
  );

  test('Filter name', () {
    final op = FilterOperations(
        dogs: fakeDogs,
        conditionSelection: ConditionSelection.name,
        operationSelection: OperationSelection.contains,
        filter: "Fido");
    List<Dog> results = op.run();
    expect(results.length, 1);
    expect(results.first.name, "Fido");
    final opTwo = FilterOperations(
        dogs: fakeDogs,
        conditionSelection: ConditionSelection.name,
        operationSelection: OperationSelection.contains,
        filter: "Fidonoep");
    final resultsTwo = opTwo.run();
    expect(resultsTwo.length, 0);
  });
  test('Filter age', () {
    final op = FilterOperations(
        dogs: fakeDogs,
        conditionSelection: ConditionSelection.age,
        operationSelection: OperationSelection.moreThan,
        filter: 1);
    List<Dog> results = op.run();
    expect(results.length, 1);
    expect(results.first.name, "Fido");
    final opTwo = FilterOperations(
        dogs: fakeDogs,
        conditionSelection: ConditionSelection.age,
        operationSelection: OperationSelection.lessThan,
        filter: 1);
    List<Dog> resultsTwo = opTwo.run();
    expect(resultsTwo.length, 0);
  });
  test('Filter tag', () {
    final op = FilterOperations(
        dogs: fakeDogs,
        conditionSelection: ConditionSelection.tag,
        operationSelection: OperationSelection.equals,
        filter: Tag(created: DateTime(2000, 1, 1), name: "dog"));
    final result = op.run();
    expect(result.length, 1);
    expect(result.first.name, "Fido");
    final opTwo = FilterOperations(
        dogs: fakeDogs,
        conditionSelection: ConditionSelection.tag,
        operationSelection: OperationSelection.equals,
        filter: Tag(created: DateTime(2000, 1, 1), name: "dogg"));
    final resultTwo = opTwo.run();
    expect(resultTwo.length, 0);
  });
  test('Filter sex', () {
    final op = FilterOperations(
        dogs: fakeDogs,
        conditionSelection: ConditionSelection.sex,
        operationSelection: OperationSelection.equals,
        filter: DogSex.male);
    final result = op.run();
    expect(result.length, 1);
    expect(result.first.name, "Fido");
    final opTwo = FilterOperations(
        dogs: fakeDogs,
        conditionSelection: ConditionSelection.sex,
        operationSelection: OperationSelection.equals,
        filter: DogSex.female);
    final rt = opTwo.run();
    expect(rt.length, 0);
  });
}
