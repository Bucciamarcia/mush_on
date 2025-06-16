import 'package:collection/collection.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/shared/dog_filter/enums.dart';

class FilterOperations {
  final List<Dog> dogs;
  final ConditionSelection conditionSelection;
  final OperationSelection operationSelection;
  final dynamic filter;
  static BasicLogger logger = BasicLogger();

  FilterOperations(
      {required this.dogs,
      required this.conditionSelection,
      required this.operationSelection,
      required this.filter});

  List<Dog> run() {
    List<Dog> toReturn;
    switch (conditionSelection) {
      case ConditionSelection.name:
        toReturn = _processName(filter);
      case ConditionSelection.age:
        toReturn = _processAge(filter);
      case ConditionSelection.tag:
        toReturn = _processTag(filter);
      case ConditionSelection.sex:
        toReturn = _processSex(filter);
      case ConditionSelection.position:
        toReturn = _processPosition(filter);
      case ConditionSelection.customField:
        toReturn = _processCustomField(filter);
    }
    toReturn.sort((a, b) => a.name.compareTo(b.name));
    return toReturn;
  }

  List<Dog> _processCustomField(FilterCustomFieldResults filter) {
    switch (operationSelection) {
      // --- STRING-BASED OPERATIONS ---
      case OperationSelection.equals:
      case OperationSelection.equalsNot:
      case OperationSelection.contains:
        // Get the filter value as a string ONCE.
        final filterValue = filter.value.getStringValue().toLowerCase();

        return dogs.where((dog) {
          final selectedCustomField = dog.customFields
              .firstWhereOrNull((cf) => cf.templateId == filter.template.id);

          // If a dog doesn't have the field, it can't match.
          if (selectedCustomField == null) {
            // For 'equalsNot', a non-existent field could be considered "not equal".
            return operationSelection == OperationSelection.equalsNot;
          }

          final dogValue =
              selectedCustomField.value.getStringValue().toLowerCase();

          return switch (operationSelection) {
            OperationSelection.equals => dogValue == filterValue,
            OperationSelection.equalsNot => dogValue != filterValue,
            OperationSelection.contains => dogValue.contains(filterValue),
            // Default case to satisfy the switch expression
            _ => false,
          };
        }).toList();

      // --- NUMERIC-BASED OPERATIONS ---
      case OperationSelection.moreThan:
      case OperationSelection.lessThan:
        // 1. VALIDATE INPUTS FIRST
        // Use pattern matching to safely get the numeric value from the filter.
        final int filterValueNum = switch (filter.value) {
          IntValue(:final value) => value,
          _ => throw IllegalFilterException(
              message:
                  "A non-number value was provided for a numeric comparison."),
        };

        // 2. LOOP CLEANLY
        return dogs.where((dog) {
          final selectedCustomField = dog.customFields
              .firstWhereOrNull((cf) => cf.templateId == filter.template.id);

          if (selectedCustomField == null) return false;

          // Safely get the numeric value from the dog's field.
          final int? dogValueNum = switch (selectedCustomField.value) {
            IntValue(:final value) => value,
            // If the dog's field isn't a number, it can't be compared.
            _ => null,
          };

          if (dogValueNum == null) return false;

          // Perform the correct comparison
          return switch (operationSelection) {
            OperationSelection.moreThan => dogValueNum > filterValueNum,
            OperationSelection.lessThan => dogValueNum < filterValueNum,
            _ => false,
          };
        }).toList();
    }
  }

  List<Dog> _processPosition(String filter) {
    switch (operationSelection) {
      case OperationSelection.moreThan:
        logger.error("Illegal operation");
        throw IllegalOperationException(
            message: "Selected illegal operation: moreThan");
      case OperationSelection.lessThan:
        logger.error("Illegal operation");
        throw IllegalOperationException(
            message: "Selected illegal operation: lessthan");
      case OperationSelection.equals:
        try {
          return dogs.where((dog) {
            List<String> canRunPositions = dog.positions.getTrue();
            if (canRunPositions.contains(filter)) return true;
            return false;
          }).toList();
        } catch (e, s) {
          logger.error("Error in process position equals operation",
              error: e, stackTrace: s);
          rethrow;
        }
      case OperationSelection.contains:
        logger.error("Illegal operation");
        throw IllegalOperationException(
            message: "Selected illegal operation: contains");
      case OperationSelection.equalsNot:
        try {
          return dogs.where((dog) {
            List<String> canRunPositions = dog.positions.getTrue();
            if (canRunPositions.contains(filter)) return false;
            return true;
          }).toList();
        } catch (e, s) {
          logger.error("Error in process position equals operation",
              error: e, stackTrace: s);
          rethrow;
        }
    }
  }

  List<Dog> _processName(String filter) {
    filter = filter.trimRight();
    switch (operationSelection) {
      case OperationSelection.equals:
        return dogs
            .where((dog) => dog.name.toLowerCase() == filter.toLowerCase())
            .toList();
      case OperationSelection.contains:
        return dogs
            .where(
                (dog) => dog.name.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      case OperationSelection.moreThan:
        logger.error("Illegal operation in processname");
        throw IllegalOperationException(
            message: "Selected illegal operation: moreThan");
      case OperationSelection.lessThan:
        logger.error("Illegal operation in processname");
        throw IllegalOperationException(
            message: "Selected illegal operation: lessthan");
      case OperationSelection.equalsNot:
        return dogs
            .where(
                (dog) => !dog.name.toLowerCase().contains(filter.toLowerCase()))
            .toList();
    }
  }

  List<Dog> _processAge(int filter) {
    switch (operationSelection) {
      case OperationSelection.equals:
        return dogs.where((dog) => dog.years == filter).toList();
      case OperationSelection.contains:
        logger.error("Illegal operation in processname");
        throw IllegalOperationException(
            message: "Selected illegal operation: contains");
      case OperationSelection.moreThan:
        return dogs
            .where((dog) => (dog.years == null) ? false : dog.years! > filter)
            .toList();
      case OperationSelection.lessThan:
        return dogs
            .where((dog) => (dog.years == null) ? false : dog.years! < filter)
            .toList();
      case OperationSelection.equalsNot:
        return dogs.where((dog) => dog.years != filter).toList();
    }
  }

  List<Dog> _processTag(Tag filter) {
    switch (operationSelection) {
      case OperationSelection.equals:
        return dogs.where((dog) {
          for (Tag tag in dog.tags.available) {
            if (tag.name == filter.name) return true;
          }
          return false;
        }).toList();
      case OperationSelection.contains:
        logger.error("Illegal operation in processname");
        throw IllegalOperationException(
            message: "Selected illegal operation: contains");
      case OperationSelection.moreThan:
        logger.error("Illegal operation in processname");
        throw IllegalOperationException(
            message: "Selected illegal operation: moreThan");
      case OperationSelection.lessThan:
        logger.error("Illegal operation in processname");
        throw IllegalOperationException(
            message: "Selected illegal operation: lessthan");
      case OperationSelection.equalsNot:
        return dogs.where((dog) {
          for (Tag tag in dog.tags.available) {
            if (tag.name == filter.name) return false;
          }
          return true;
        }).toList();
    }
  }

  List<Dog> _processSex(DogSex filter) {
    switch (operationSelection) {
      case OperationSelection.equals:
        return dogs.where((dog) => dog.sex == filter).toList();
      case OperationSelection.equalsNot:
        return dogs.where((dog) => dog.sex != filter).toList();
      case OperationSelection.contains:
        logger.error("Illegal operation in processname");
        throw IllegalOperationException(
            message: "Selected illegal operation: contains");
      case OperationSelection.moreThan:
        logger.error("Illegal operation in processname");
        throw IllegalOperationException(
            message: "Selected illegal operation: moreThan");
      case OperationSelection.lessThan:
        logger.error("Illegal operation in processname");
        throw IllegalOperationException(
            message: "Selected illegal operation: lessThan");
    }
  }
}

/// The user has selected an illegal operation
class IllegalOperationException implements Exception {
  final String message;
  IllegalOperationException({required this.message});
  @override
  String toString() => 'IllegalOperationException: $message';
}

/// The filter the user selected contains an illegal value
class IllegalFilterException implements Exception {
  final String message;
  IllegalFilterException({required this.message});
  @override
  String toString() => 'IllegalFilterException: $message';
}
