import 'package:mush_on/services/models.dart';

final List<Dog> fakeDogs = [
  Dog(
    name: "Fido",
    id: "id_Fido",
    positions: DogPositions(lead: true),
    birth: DateTime(2000, 1, 1),
    tags: [
      Tag(created: DateTime(2000, 1, 1), id: "1", name: "dog"),
    ],
    sex: DogSex.male,
  ),
  Dog(name: "Fluffy", id: "id_Fluffy", positions: DogPositions(swing: true)),
  Dog(name: "Wheeler", id: "id_Wheeler", positions: DogPositions(wheel: true)),
];
