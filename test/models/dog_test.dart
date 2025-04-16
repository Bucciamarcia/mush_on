// Import the test package
import 'package:mush_on/services/models/dog.dart';
import 'package:test/test.dart';

void main() {
  // Group tests related to DogPositions serialization
  group('DogPositions JSON Serialization', () {
    // --- Test Data for DogPositions ---
    final testDogPositionsObject = DogPositions(
      lead: true,
      swing: false,
      team: true,
      wheel: false,
    );
    final testDogPositionsJson = <String, dynamic>{
      'lead': true,
      'swing': false,
      'team': true,
      'wheel': false,
    };

    test('fromJson creates correct DogPositions object', () {
      final positionsFromJson = DogPositions.fromJson(testDogPositionsJson);
      expect(positionsFromJson.lead, equals(testDogPositionsObject.lead));
      expect(positionsFromJson.swing, equals(testDogPositionsObject.swing));
      expect(positionsFromJson.team, equals(testDogPositionsObject.team));
      expect(positionsFromJson.wheel, equals(testDogPositionsObject.wheel));
    });

    test('toJson creates correct JSON map', () {
      final jsonFromPositions = testDogPositionsObject.toJson();
      expect(jsonFromPositions, equals(testDogPositionsJson));
    });

    test('fromJson handles missing keys with default values', () {
      final partialJson = <String, dynamic>{'lead': true};
      final positionsFromJson = DogPositions.fromJson(partialJson);
      expect(positionsFromJson.lead, isTrue);
      expect(positionsFromJson.swing, isFalse);
      expect(positionsFromJson.team, isFalse);
      expect(positionsFromJson.wheel, isFalse);
    });
  });

  // Group tests related to Dog serialization
  group('Dog JSON Serialization', () {
    // --- Test Data for Dog ---
    final testDogObject = Dog(
      name: "Buddy",
      id: "dog123",
      positions:
          DogPositions(lead: true, swing: false, team: true, wheel: false),
    );
    final testDogJson = <String, dynamic>{
      'name': "Buddy",
      'id': "dog123",
      'positions': <String, dynamic>{
        'lead': true,
        'swing': false,
        'team': true,
        'wheel': false,
      },
    };
    final testDogObjectDefaultPos = Dog(
      name: "Rookie",
      id: "dog456",
      // positions will be defaulted
    );
    final testDogJsonDefaultPos = <String, dynamic>{
      'name': "Rookie",
      'id': "dog456",
      'positions': <String, dynamic>{
        'lead': false,
        'swing': false,
        'team': false,
        'wheel': false,
      },
    };

    test('fromJson creates correct Dog object with nested positions', () {
      final dogFromJson = Dog.fromJson(testDogJson);
      expect(dogFromJson.name, equals(testDogObject.name));
      expect(dogFromJson.id, equals(testDogObject.id));
      expect(dogFromJson.positions.lead, equals(testDogObject.positions.lead));
      expect(
          dogFromJson.positions.swing, equals(testDogObject.positions.swing));
      expect(dogFromJson.positions.team, equals(testDogObject.positions.team));
      expect(
          dogFromJson.positions.wheel, equals(testDogObject.positions.wheel));
    });

    test('toJson creates correct JSON map with nested positions', () {
      final jsonFromDog = testDogObject.toJson();
      expect(jsonFromDog, equals(testDogJson));
    });

    test('fromJson creates correct Dog object with default positions', () {
      final dogFromJson = Dog.fromJson(testDogJsonDefaultPos);
      expect(dogFromJson.name, equals(testDogObjectDefaultPos.name));
      expect(dogFromJson.id, equals(testDogObjectDefaultPos.id));
      expect(dogFromJson.positions.lead, isFalse);
      expect(dogFromJson.positions.swing, isFalse);
      expect(dogFromJson.positions.team, isFalse);
      expect(dogFromJson.positions.wheel, isFalse);
    });

    test('toJson creates correct JSON map with default positions', () {
      final jsonFromDog = testDogObjectDefaultPos.toJson();
      expect(jsonFromDog, equals(testDogJsonDefaultPos));
    });
  });

  // --- NEW TESTS for Freezed Functionality ---
  group('Dog Freezed Functionality', () {
    // Base object for comparison and copyWith tests
    final baseDog = Dog(
      name: "Max",
      id: "dog789",
      positions:
          DogPositions(lead: false, swing: true, team: false, wheel: true),
    );

    // Test copyWith functionality
    group('copyWith', () {
      test('returns identical object when no arguments provided', () {
        final copiedDog = baseDog.copyWith();
        // Should be a different instance but equal in value
        expect(copiedDog, equals(baseDog));
        expect(identical(copiedDog, baseDog), isFalse);
      });

      test('correctly copies with updated name', () {
        const newName = "Charlie";
        final copiedDog = baseDog.copyWith(name: newName);
        expect(copiedDog.name, equals(newName));
        expect(copiedDog.id, equals(baseDog.id)); // Should remain unchanged
        expect(copiedDog.positions,
            equals(baseDog.positions)); // Should remain unchanged
      });

      test('correctly copies with updated id', () {
        const newId = "dogABC";
        final copiedDog = baseDog.copyWith(id: newId);
        expect(copiedDog.id, equals(newId));
        expect(copiedDog.name, equals(baseDog.name)); // Should remain unchanged
        expect(copiedDog.positions,
            equals(baseDog.positions)); // Should remain unchanged
      });

      test('correctly copies with updated positions', () {
        final newPositions =
            DogPositions(lead: true, swing: true, team: true, wheel: true);
        final copiedDog = baseDog.copyWith(positions: newPositions);
        expect(copiedDog.positions, equals(newPositions));
        expect(copiedDog.name, equals(baseDog.name)); // Should remain unchanged
        expect(copiedDog.id, equals(baseDog.id)); // Should remain unchanged
      });
    });

    // Test equality (== operator)
    group('Equality (==)', () {
      test('returns true for two instances with identical values', () {
        final dog1 = Dog(
          name: "Max",
          id: "dog789",
          positions:
              DogPositions(lead: false, swing: true, team: false, wheel: true),
        );
        // baseDog has the same values
        expect(dog1, equals(baseDog));
      });

      test('returns false if name differs', () {
        final dog1 = baseDog.copyWith(name: "Different Name");
        expect(dog1, isNot(equals(baseDog)));
      });

      test('returns false if id differs', () {
        final dog1 = baseDog.copyWith(id: "different-id");
        expect(dog1, isNot(equals(baseDog)));
      });

      test('returns false if positions differ', () {
        final dog1 = baseDog.copyWith(
            positions: DogPositions(lead: true)); // Different positions
        expect(dog1, isNot(equals(baseDog)));
      });

      test('returns false for comparison with null', () {
        expect(baseDog == null, isFalse);
      });

      test('returns false for comparison with different type', () {
        expect(baseDog == "some string", isFalse);
      });
    });

    // Test hashCode
    group('hashCode', () {
      test('is equal for two instances with identical values', () {
        final dog1 = Dog(
          name: "Max",
          id: "dog789",
          positions:
              DogPositions(lead: false, swing: true, team: false, wheel: true),
        );
        // baseDog has the same values
        expect(dog1.hashCode, equals(baseDog.hashCode));
      });

      test('is likely different for instances with different values', () {
        final dog1 = baseDog.copyWith(name: "Different Name");
        // Note: Hash collisions are possible but unlikely for simple changes.
        // The primary guarantee is that equal objects MUST have equal hashCodes.
        expect(dog1.hashCode, isNot(equals(baseDog.hashCode)));
      });
    });

    // Test toString (optional, format might change between versions)
    // test('toString contains class name and properties', () {
    //   final stringRepresentation = baseDog.toString();
    //   expect(stringRepresentation, startsWith('Dog('));
    //   expect(stringRepresentation, contains('name: Max'));
    //   expect(stringRepresentation, contains('id: dog789'));
    //   expect(stringRepresentation, contains('positions: DogPositions('));
    // });
  });
}
