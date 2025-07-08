import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@riverpod
class AddDog extends _$AddDog {
  @override
  AddDogData build() {
    return AddDogData();
  }

  void changeName(String newName) {
    Dog updatedDog = state.dog.copyWith(name: newName);
    state = state.copyWith(dog: updatedDog);
  }

  void changeImage(File? file) {
    state = state.copyWith(file: file);
  }

  void changePositions(DogPositions newPositions) {
    Dog updatedDog = state.dog.copyWith(positions: newPositions);
    state = state.copyWith(dog: updatedDog);
  }
}

@freezed
sealed class AddDogData with _$AddDogData {
  factory AddDogData({
    @Default(Dog()) Dog dog,
    File? file,
  }) = _AddDogData;
}
