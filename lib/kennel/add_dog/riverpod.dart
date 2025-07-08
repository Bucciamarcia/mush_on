import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/notes.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
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

  void addTag(Tag tag) {
    List<Tag> updatedTags = List.from(state.dog.tags)..add(tag);
    Dog updatedDog = state.dog.copyWith(tags: updatedTags);
    state = state.copyWith(dog: updatedDog);
  }

  /// Replaces the tag with the same id
  void changeTag(Tag newTag) {
    var newTags = List<Tag>.from(state.dog.tags);
    newTags.removeWhere((tag) => tag.id == newTag.id);
    newTags.add(newTag);
    var newDog = state.dog.copyWith(tags: newTags);
    state = state.copyWith(dog: newDog);
  }

  void deleteTag(Tag tag) {
    List<Tag> updatedTags = List.from(state.dog.tags)
      ..removeWhere((t) => t.id == tag.id);
    Dog updatedDog = state.dog.copyWith(tags: updatedTags);
    state = state.copyWith(dog: updatedDog);
  }

  void changeBirthday(DateTime? newBirthday) {
    Dog updatedDog = state.dog.copyWith(birth: newBirthday);
    state = state.copyWith(dog: updatedDog);
  }

  void changeSex(DogSex newSex) {
    Dog updatedDog = state.dog.copyWith(sex: newSex);
    state = state.copyWith(dog: updatedDog);
  }

  void addDistanceWarning(DistanceWarning w) {
    var newWarnings = List<DistanceWarning>.from(state.dog.distanceWarnings);
    newWarnings.add(w);
    var newDog = state.dog.copyWith(distanceWarnings: newWarnings);
    state = state.copyWith(dog: newDog);
  }

  void updateWarning(DistanceWarning w) {
    var newWarnings = List<DistanceWarning>.from(state.dog.distanceWarnings);
    newWarnings.removeWhere((war) => war.id == w.id);
    newWarnings.add(w);
    var newDog = state.dog.copyWith(distanceWarnings: newWarnings);
    state = state.copyWith(dog: newDog);
  }

  void removeWarning(String id) {
    var newWarnings = List<DistanceWarning>.from(state.dog.distanceWarnings);
    newWarnings.removeWhere((war) => war.id == id);
    var newDog = state.dog.copyWith(distanceWarnings: newWarnings);
    state = state.copyWith(dog: newDog);
  }

  void editCustomFields(CustomField newCf) {
    var customFields = List<CustomField>.from(state.dog.customFields);
    customFields.removeWhere((cf) => cf.templateId == newCf.templateId);
    customFields.add(newCf);
    var newDog = state.dog.copyWith(customFields: customFields);
    state = state.copyWith(dog: newDog);
  }

  void deleteCustomField(String templateId) {
    var customFields = List<CustomField>.from(state.dog.customFields);
    customFields.removeWhere((cf) => cf.templateId == templateId);
    var newDog = state.dog.copyWith(customFields: customFields);
    state = state.copyWith(dog: newDog);
  }

  void addNote(SingleDogNote note) {
    var newNotes = List<SingleDogNote>.from(state.dog.notes);
    newNotes.add(note);
    var newDog = state.dog.copyWith(notes: newNotes);
    state = state.copyWith(dog: newDog);
  }

  void deleteNote(String noteId) {
    var newNotes = List<SingleDogNote>.from(state.dog.notes);
    newNotes.removeWhere((note) => note.id == noteId);
    var newDog = state.dog.copyWith(notes: newNotes);
    state = state.copyWith(dog: newDog);
  }
}

@freezed
sealed class AddDogData with _$AddDogData {
  factory AddDogData({
    @Default(Dog()) Dog dog,
    File? file,
  }) = _AddDogData;
}
