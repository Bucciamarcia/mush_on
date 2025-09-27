import 'package:freezed_annotation/freezed_annotation.dart';
part 'stripe_models.freezed.dart';
part 'stripe_models.g.dart';

@freezed
sealed class StripeConnection with _$StripeConnection {
  const factory StripeConnection({
    required String accountId,
    @Default(false) bool isActive,
  }) = _StripeConnection;

  factory StripeConnection.fromJson(Map<String, dynamic> json) =>
      _$StripeConnectionFromJson(json);
}
