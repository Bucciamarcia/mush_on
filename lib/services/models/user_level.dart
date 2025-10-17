import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum UserLevel {
  /// Admin access. Everything.
  musher(rank: 100),

  /// Worker.
  handler(rank: 50),

  /// Rank 0, everyone.
  guest(rank: 0);

  /// Numerical representation of the level of permission this role has. Higher = more access.
  final int rank;
  const UserLevel({required this.rank});
}
