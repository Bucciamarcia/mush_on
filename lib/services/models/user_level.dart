import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum UserLevel {
  /// Admin access. Everything.
  musher(rank: 100, description: "Administrator. Can do everything."),

  /// Worker.
  handler(
      rank: 50,
      description:
          "Can handle every dog-related matter, but can't add/remove users or see financial data."),

  /// Rank 0, everyone.
  guest(rank: 0, description: "A guest. Cannot do almost anything.");

  /// Numerical representation of the level of permission this role has. Higher = more access.
  final int rank;

  /// User friendly description of the role.
  final String description;
  const UserLevel({required this.rank, required this.description});
}
