import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
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
    switch (conditionSelection) {
      case ConditionSelection.name:
        return _processName(filter);
      case ConditionSelection.age:
        return _processAge(filter);
      case ConditionSelection.tag:
        return _processTag(filter);
      case ConditionSelection.sex:
        return _processSex(filter);
    }
  }

  List<Dog> _processName(String filter) {
    switch (operationSelection) {
      case OperationSelection.equals:
        return dogs.where((dog) => dog.name == filter).toList();
      case OperationSelection.contains:
        return dogs.where((dog) => dog.name.contains(filter)).toList();
      case OperationSelection.moreThan:
        logger.error("Illegal operation in processname");
        throw IllegalOperationException(
            message: "Selected illegal operation: moreThan");
      case OperationSelection.lessThan:
        logger.error("Illegal operation in processname");
        throw IllegalOperationException(
            message: "Selected illegal operation: lessthan");
      case OperationSelection.equalsNot:
        return dogs.where((dog) => !dog.name.contains(filter)).toList();
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
          for (Tag tag in dog.tags) {
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
          for (Tag tag in dog.tags) {
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
