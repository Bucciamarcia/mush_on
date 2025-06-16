import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/shared/dog_filter/enums.dart';
import 'package:mush_on/shared/dog_filter/filter_operations.dart';

void main() {
  group('FilterOperations', () {
    late List<Dog> testDogs;
    late Tag testTag1, testTag2;
    late CustomFieldTemplate stringTemplate, numberTemplate;

    setUp(() {
      testTag1 = Tag(id: "tag1", name: "Active", created: DateTime.now());
      testTag2 = Tag(id: "tag2", name: "Retired", created: DateTime.now());

      stringTemplate = CustomFieldTemplate(
        id: "string_field",
        name: "Notes",
        type: CustomFieldType.typeString,
      );

      numberTemplate = CustomFieldTemplate(
        id: "number_field", 
        name: "Speed",
        type: CustomFieldType.typeInt,
      );

      testDogs = [
        Dog(
          id: "1",
          name: "Alpha",
          sex: DogSex.male,
          birth: DateTime(2020, 1, 1),
          positions: DogPositions(lead: true, swing: false, team: false, wheel: false),
          tags: [testTag1],
          customFields: [
            CustomField(templateId: stringTemplate.id, value: const CustomFieldValue.stringValue("Fast runner")),
            CustomField(templateId: numberTemplate.id, value: const CustomFieldValue.intValue(15)),
          ],
        ),
        Dog(
          id: "2", 
          name: "Beta",
          sex: DogSex.female,
          birth: DateTime(2019, 6, 15),
          positions: DogPositions(lead: false, swing: true, team: false, wheel: false),
          tags: [testTag2],
          customFields: [
            CustomField(templateId: stringTemplate.id, value: const CustomFieldValue.stringValue("Slow walker")),
            CustomField(templateId: numberTemplate.id, value: const CustomFieldValue.intValue(8)),
          ],
        ),
        Dog(
          id: "3",
          name: "Charlie", 
          sex: DogSex.male,
          birth: DateTime(2021, 3, 10),
          positions: DogPositions(lead: false, swing: false, team: true, wheel: false),
          tags: [],
          customFields: [],
        ),
        Dog(
          id: "4",
          name: "Delta",
          sex: DogSex.female,
          birth: DateTime(2018, 12, 5),
          positions: DogPositions(lead: false, swing: false, team: false, wheel: true),
          tags: [testTag1, testTag2],
          customFields: [
            CustomField(templateId: stringTemplate.id, value: const CustomFieldValue.stringValue("Average speed")),
          ],
        ),
      ];
    });

    group('Name filtering', () {
      test('equals operation - case insensitive', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.name,
          operationSelection: OperationSelection.equals,
          filter: "alpha",
        );

        final result = filter.run();
        expect(result.length, 1);
        expect(result.first.name, "Alpha");
      });

      test('contains operation - case insensitive', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.name,
          operationSelection: OperationSelection.contains,
          filter: "a",
        );

        final result = filter.run();
        expect(result.length, 4); // Alpha, Beta, Charlie, Delta all contain 'a'
        expect(result.map((d) => d.name).toList(), ["Alpha", "Beta", "Charlie", "Delta"]);
      });

      test('equalsNot operation - actually implements not contains', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.name,
          operationSelection: OperationSelection.equalsNot,
          filter: "lph", // Should exclude "Alpha" which contains "lph"
        );

        final result = filter.run();
        expect(result.length, 3); // Beta, Charlie, Delta don't contain "lph"
        expect(result.map((d) => d.name).contains("Alpha"), false);
        expect(result.map((d) => d.name).toList(), ["Beta", "Charlie", "Delta"]);
      });

      test('trims whitespace from filter', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.name,
          operationSelection: OperationSelection.equals,
          filter: "Alpha   ",
        );

        final result = filter.run();
        expect(result.length, 1);
        expect(result.first.name, "Alpha");
      });

      test('throws IllegalOperationException for moreThan', () {
        expect(
          () => FilterOperations(
            dogs: testDogs,
            conditionSelection: ConditionSelection.name,
            operationSelection: OperationSelection.moreThan,
            filter: "Alpha",
          ).run(),
          throwsA(isA<IllegalOperationException>()),
        );
      });

      test('throws IllegalOperationException for lessThan', () {
        expect(
          () => FilterOperations(
            dogs: testDogs,
            conditionSelection: ConditionSelection.name,
            operationSelection: OperationSelection.lessThan,
            filter: "Alpha",
          ).run(),
          throwsA(isA<IllegalOperationException>()),
        );
      });
    });

    group('Age filtering', () {
      test('equals operation', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.age,
          operationSelection: OperationSelection.equals,
          filter: 4, // Charlie is 4 years old
        );

        final result = filter.run();
        expect(result.length, 1);
        expect(result.first.name, "Charlie");
      });

      test('moreThan operation', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.age,
          operationSelection: OperationSelection.moreThan,
          filter: 5,
        );

        final result = filter.run();
        expect(result.length, 2); // Beta (6) and Delta (6)
        expect(result.map((d) => d.name).toList(), ["Beta", "Delta"]);
      });

      test('lessThan operation', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.age,
          operationSelection: OperationSelection.lessThan,
          filter: 6,
        );

        final result = filter.run();
        expect(result.length, 2); // Alpha (5) and Charlie (4)
        expect(result.map((d) => d.name).toList(), ["Alpha", "Charlie"]);
      });

      test('equalsNot operation', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.age,
          operationSelection: OperationSelection.equalsNot,
          filter: 4,
        );

        final result = filter.run();
        expect(result.length, 3); // All except Charlie (age 4)
        expect(result.map((d) => d.name).contains("Charlie"), false);
        expect(result.map((d) => d.name).toList(), ["Alpha", "Beta", "Delta"]);
      });

      test('handles null ages correctly', () {
        final dogWithNullAge = Dog(
          id: "null_age",
          name: "NullAge",
          birth: null,
          positions: DogPositions(),
          tags: [],
          customFields: [],
        );

        final dogsWithNull = [...testDogs, dogWithNullAge];

        final filter = FilterOperations(
          dogs: dogsWithNull,
          conditionSelection: ConditionSelection.age,
          operationSelection: OperationSelection.moreThan,
          filter: 0,
        );

        final result = filter.run();
        expect(result.map((d) => d.name).contains("NullAge"), false);
      });

      test('throws IllegalOperationException for contains', () {
        expect(
          () => FilterOperations(
            dogs: testDogs,
            conditionSelection: ConditionSelection.age,
            operationSelection: OperationSelection.contains,
            filter: 4,
          ).run(),
          throwsA(isA<IllegalOperationException>()),
        );
      });
    });

    group('Tag filtering', () {
      test('equals operation', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.tag,
          operationSelection: OperationSelection.equals,
          filter: testTag1,
        );

        final result = filter.run();
        expect(result.length, 2); // Alpha and Delta have testTag1
        expect(result.map((d) => d.name).toList(), ["Alpha", "Delta"]);
      });

      test('equalsNot operation', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.tag,
          operationSelection: OperationSelection.equalsNot,
          filter: testTag1,
        );

        final result = filter.run();
        expect(result.length, 2); // Beta and Charlie don't have testTag1
        expect(result.map((d) => d.name).toList(), ["Beta", "Charlie"]);
      });

      test('throws IllegalOperationException for contains', () {
        expect(
          () => FilterOperations(
            dogs: testDogs,
            conditionSelection: ConditionSelection.tag,
            operationSelection: OperationSelection.contains,
            filter: testTag1,
          ).run(),
          throwsA(isA<IllegalOperationException>()),
        );
      });

      test('throws IllegalOperationException for moreThan', () {
        expect(
          () => FilterOperations(
            dogs: testDogs,
            conditionSelection: ConditionSelection.tag,
            operationSelection: OperationSelection.moreThan,
            filter: testTag1,
          ).run(),
          throwsA(isA<IllegalOperationException>()),
        );
      });

      test('throws IllegalOperationException for lessThan', () {
        expect(
          () => FilterOperations(
            dogs: testDogs,
            conditionSelection: ConditionSelection.tag,
            operationSelection: OperationSelection.lessThan,
            filter: testTag1,
          ).run(),
          throwsA(isA<IllegalOperationException>()),
        );
      });
    });

    group('Sex filtering', () {
      test('equals operation', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.sex,
          operationSelection: OperationSelection.equals,
          filter: DogSex.male,
        );

        final result = filter.run();
        expect(result.length, 2); // Alpha and Charlie
        expect(result.map((d) => d.name).toList(), ["Alpha", "Charlie"]);
      });

      test('equalsNot operation', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.sex,
          operationSelection: OperationSelection.equalsNot,
          filter: DogSex.male,
        );

        final result = filter.run();
        expect(result.length, 2); // Beta and Delta
        expect(result.map((d) => d.name).toList(), ["Beta", "Delta"]);
      });

      test('throws IllegalOperationException for contains', () {
        expect(
          () => FilterOperations(
            dogs: testDogs,
            conditionSelection: ConditionSelection.sex,
            operationSelection: OperationSelection.contains,
            filter: DogSex.male,
          ).run(),
          throwsA(isA<IllegalOperationException>()),
        );
      });

      test('throws IllegalOperationException for moreThan', () {
        expect(
          () => FilterOperations(
            dogs: testDogs,
            conditionSelection: ConditionSelection.sex,
            operationSelection: OperationSelection.moreThan,
            filter: DogSex.male,
          ).run(),
          throwsA(isA<IllegalOperationException>()),
        );
      });

      test('throws IllegalOperationException for lessThan', () {
        expect(
          () => FilterOperations(
            dogs: testDogs,
            conditionSelection: ConditionSelection.sex,
            operationSelection: OperationSelection.lessThan,
            filter: DogSex.male,
          ).run(),
          throwsA(isA<IllegalOperationException>()),
        );
      });
    });

    group('Position filtering', () {
      test('equals operation', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.position,
          operationSelection: OperationSelection.equals,
          filter: "Lead", // Capital L to match DogPositions.getTrue()
        );

        final result = filter.run();
        expect(result.length, 1); // Only Alpha is lead
        expect(result.first.name, "Alpha");
      });

      test('equalsNot operation', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.position,
          operationSelection: OperationSelection.equalsNot,
          filter: "Lead", // Capital L to match DogPositions.getTrue()
        );

        final result = filter.run();
        expect(result.length, 3); // Beta, Charlie, Delta are not lead
        expect(result.map((d) => d.name).toList(), ["Beta", "Charlie", "Delta"]);
      });

      test('filters by swing position', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.position,
          operationSelection: OperationSelection.equals,
          filter: "Swing", // Capital S to match DogPositions.getTrue()
        );

        final result = filter.run();
        expect(result.length, 1); // Only Beta is swing
        expect(result.first.name, "Beta");
      });

      test('filters by team position', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.position,
          operationSelection: OperationSelection.equals,
          filter: "Team", // Capital T to match DogPositions.getTrue()
        );

        final result = filter.run();
        expect(result.length, 1); // Only Charlie is team
        expect(result.first.name, "Charlie");
      });

      test('filters by wheel position', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.position,
          operationSelection: OperationSelection.equals,
          filter: "Wheel", // Capital W to match DogPositions.getTrue()
        );

        final result = filter.run();
        expect(result.length, 1); // Only Delta is wheel
        expect(result.first.name, "Delta");
      });

      test('throws IllegalOperationException for contains', () {
        expect(
          () => FilterOperations(
            dogs: testDogs,
            conditionSelection: ConditionSelection.position,
            operationSelection: OperationSelection.contains,
            filter: "Lead",
          ).run(),
          throwsA(isA<IllegalOperationException>()),
        );
      });

      test('throws IllegalOperationException for moreThan', () {
        expect(
          () => FilterOperations(
            dogs: testDogs,
            conditionSelection: ConditionSelection.position,
            operationSelection: OperationSelection.moreThan,
            filter: "Lead",
          ).run(),
          throwsA(isA<IllegalOperationException>()),
        );
      });

      test('throws IllegalOperationException for lessThan', () {
        expect(
          () => FilterOperations(
            dogs: testDogs,
            conditionSelection: ConditionSelection.position,
            operationSelection: OperationSelection.lessThan,
            filter: "Lead",
          ).run(),
          throwsA(isA<IllegalOperationException>()),
        );
      });
    });

    group('Custom field filtering - String values', () {
      test('equals operation - case insensitive', () {
        final filterValue = FilterCustomFieldResults(
          template: stringTemplate,
          value: const CustomFieldValue.stringValue("FAST RUNNER"),
        );

        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.customField,
          operationSelection: OperationSelection.equals,
          filter: filterValue,
        );

        final result = filter.run();
        expect(result.length, 1); // Only Alpha has "Fast runner"
        expect(result.first.name, "Alpha");
      });

      test('equalsNot operation', () {
        final filterValue = FilterCustomFieldResults(
          template: stringTemplate,
          value: const CustomFieldValue.stringValue( "Fast runner"),
        );

        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.customField,
          operationSelection: OperationSelection.equalsNot,
          filter: filterValue,
        );

        final result = filter.run();
        expect(result.length, 3); // Beta, Charlie (no field), Delta
        expect(result.map((d) => d.name).toList(), ["Beta", "Charlie", "Delta"]);
      });

      test('contains operation - case insensitive', () {
        final filterValue = FilterCustomFieldResults(
          template: stringTemplate,
          value: const CustomFieldValue.stringValue("speed"),
        );

        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.customField,
          operationSelection: OperationSelection.contains,
          filter: filterValue,
        );

        final result = filter.run();
        expect(result.length, 1); // Only Delta has "Average speed"
        expect(result.first.name, "Delta");
      });

      test('handles dogs without the custom field - equals', () {
        final filterValue = FilterCustomFieldResults(
          template: stringTemplate,
          value: const CustomFieldValue.stringValue("nonexistent"),
        );

        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.customField,
          operationSelection: OperationSelection.equals,
          filter: filterValue,
        );

        final result = filter.run();
        expect(result.length, 0); // No dogs match
      });

      test('handles dogs without the custom field - equalsNot', () {
        final filterValue = FilterCustomFieldResults(
          template: stringTemplate,
          value: const CustomFieldValue.stringValue("Fast runner"),
        );

        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.customField,
          operationSelection: OperationSelection.equalsNot,
          filter: filterValue,
        );

        final result = filter.run();
        // Charlie doesn't have the field, so it's considered "not equal"
        expect(result.map((d) => d.name).contains("Charlie"), true);
      });
    });

    group('Custom field filtering - Numeric values', () {
      test('moreThan operation', () {
        final filterValue = FilterCustomFieldResults(
          template: numberTemplate,
          value: const CustomFieldValue.intValue( 10),
        );

        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.customField,
          operationSelection: OperationSelection.moreThan,
          filter: filterValue,
        );

        final result = filter.run();
        expect(result.length, 1); // Only Alpha has value 15 > 10
        expect(result.first.name, "Alpha");
      });

      test('lessThan operation', () {
        final filterValue = FilterCustomFieldResults(
          template: numberTemplate,
          value: const CustomFieldValue.intValue(10),
        );

        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.customField,
          operationSelection: OperationSelection.lessThan,
          filter: filterValue,
        );

        final result = filter.run();
        expect(result.length, 1); // Only Beta has value 8 < 10
        expect(result.first.name, "Beta");
      });

      test('handles dogs without the numeric field', () {
        final filterValue = FilterCustomFieldResults(
          template: numberTemplate,
          value: const CustomFieldValue.intValue(5),
        );

        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.customField,
          operationSelection: OperationSelection.moreThan,
          filter: filterValue,
        );

        final result = filter.run();
        // Charlie and Delta don't have this field, so they're excluded
        expect(result.length, 2); // Alpha and Beta
        expect(result.map((d) => d.name).toList(), ["Alpha", "Beta"]);
      });

      test('throws IllegalFilterException for non-numeric filter value', () {
        final filterValue = FilterCustomFieldResults(
          template: numberTemplate,
          value: const CustomFieldValue.stringValue("not a number"),
        );

        expect(
          () => FilterOperations(
            dogs: testDogs,
            conditionSelection: ConditionSelection.customField,
            operationSelection: OperationSelection.moreThan,
            filter: filterValue,
          ).run(),
          throwsA(isA<IllegalFilterException>()),
        );
      });

      test('handles dogs with non-numeric values in numeric field', () {
        final dogWithStringInNumberField = Dog(
          id: "mixed",
          name: "Mixed",
          positions: DogPositions(),
          tags: [],
          customFields: [
            CustomField(templateId: numberTemplate.id, value: const CustomFieldValue.stringValue("text")),
          ],
        );

        final dogsWithMixed = [...testDogs, dogWithStringInNumberField];

        final filterValue = FilterCustomFieldResults(
          template: numberTemplate,
          value: const CustomFieldValue.intValue(10),
        );

        final filter = FilterOperations(
          dogs: dogsWithMixed,
          conditionSelection: ConditionSelection.customField,
          operationSelection: OperationSelection.moreThan,
          filter: filterValue,
        );

        final result = filter.run();
        // Mixed dog has non-numeric value, so it's excluded
        expect(result.length, 1); // Only Alpha
        expect(result.first.name, "Alpha");
      });
    });

    group('Result sorting', () {
      test('results are always sorted alphabetically by name', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.sex,
          operationSelection: OperationSelection.equals,
          filter: DogSex.female,
        );

        final result = filter.run();
        expect(result.map((d) => d.name).toList(), ["Beta", "Delta"]);
      });

      test('single result is still in list format', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.name,
          operationSelection: OperationSelection.equals,
          filter: "Alpha",
        );

        final result = filter.run();
        expect(result.length, 1);
        expect(result.first.name, "Alpha");
      });

      test('no results returns empty list', () {
        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.name,
          operationSelection: OperationSelection.equals,
          filter: "NonExistent",
        );

        final result = filter.run();
        expect(result.length, 0);
        expect(result, isEmpty);
      });
    });

    group('Edge cases', () {
      test('handles empty dog list', () {
        final filter = FilterOperations(
          dogs: [],
          conditionSelection: ConditionSelection.name,
          operationSelection: OperationSelection.contains,
          filter: "any",
        );

        final result = filter.run();
        expect(result.length, 0);
        expect(result, isEmpty);
      });

      test('handles dogs with empty names', () {
        final dogsWithEmptyName = [
          Dog(
            id: "empty",
            name: "",
            positions: DogPositions(),
            tags: [],
            customFields: [],
          ),
          ...testDogs,
        ];

        final filter = FilterOperations(
          dogs: dogsWithEmptyName,
          conditionSelection: ConditionSelection.name,
          operationSelection: OperationSelection.equals,
          filter: "",
        );

        final result = filter.run();
        expect(result.length, 1);
        expect(result.first.name, "");
      });

      test('handles custom field template that doesn\'t exist in dogs', () {
        final nonExistentTemplate = CustomFieldTemplate(
          id: "nonexistent",
          name: "NonExistent",
          type: CustomFieldType.typeString,
        );

        final filterValue = FilterCustomFieldResults(
          template: nonExistentTemplate,
          value: const CustomFieldValue.stringValue("anything"),
        );

        final filter = FilterOperations(
          dogs: testDogs,
          conditionSelection: ConditionSelection.customField,
          operationSelection: OperationSelection.equals,
          filter: filterValue,
        );

        final result = filter.run();
        expect(result.length, 0); // No dogs have this field
      });
    });
  });
}