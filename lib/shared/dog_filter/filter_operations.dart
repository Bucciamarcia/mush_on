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
    String getRawValue(CustomFieldValue cfv) {
      return switch (cfv) {
        StringValue(:final value) => value,
        IntValue(:final value) => value.toString(),
        DoubleValue(:final value) => value.toString(),
      };
    }

    final String filterValue = getRawValue(filter.value).toLowerCase();

    switch (operationSelection) {
      case OperationSelection.equals:
        try {
          return dogs.where((dog) {
            final selectedCustomField = dog.customFields
                .firstWhereOrNull((cf) => cf.templateId == filter.template.id);
            if (selectedCustomField == null) return false;
            final dogValue =
                getRawValue(selectedCustomField.value).toLowerCase();
            return dogValue == filterValue;
          }).toList();
        } catch (e, s) {
          logger.error("Couldn't process custom field equals.",
              error: e, stackTrace: s);
          rethrow;
        }
      case OperationSelection.equalsNot:
        try {
          return dogs.where((dog) {
            final selectedCustomField = dog.customFields
                .firstWhereOrNull((cf) => cf.templateId == filter.template.id);
            if (selectedCustomField == null) return true;
            final dogValue =
                getRawValue(selectedCustomField.value).toLowerCase();
            return dogValue != filterValue;
          }).toList();
        } catch (e, s) {
          logger.error("Couldn't process custom field equalsNot.",
              error: e, stackTrace: s);
          rethrow;
        }
      case OperationSelection.contains:
        try {
          return dogs.where((dog) {
            final selectedCustomField = dog.customFields
                .firstWhereOrNull((cf) => cf.templateId == filter.template.id);
            if (selectedCustomField == null) return false;
            final dogValue =
                getRawValue(selectedCustomField.value).toLowerCase();
            return dogValue.contains(filterValue);
          }).toList();
        } catch (e, s) {
          logger.error("Couldn't process custom field contains.",
              error: e, stackTrace: s);
          rethrow;
        }
      case OperationSelection.moreThan:
      case OperationSelection.lessThan:
        logger.error("Illegal operation");
        throw IllegalOperationException(
            message: "Selected illegal operation: $operationSelection");
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

class IllegalOperationException implements Exception {
  final String message;
  IllegalOperationException({required this.message});
  @override
  String toString() => 'IllegalOperationException: $message';
}
