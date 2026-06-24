import 'package:freezed_annotation/freezed_annotation.dart';
part 'models.g.dart';
part 'models.freezed.dart';

@freezed

/// A B2B reseller who books on behalf of their own customers.
/// Identified by a `&partner=<code>` URL param on the booking page.
sealed class Partner with _$Partner {
  const factory Partner({
    /// ALSO stored as a field in the doc (never rely on doc.id alone).
    required String id,

    /// Internal display name.
    @Default("") String name,

    /// The value used in `&partner=<code>`.
    @Default("") String code,

    /// ALWAYS the recipient of payment emails.
    String? email,

    /// Fraction 0..1 (e.g. 0.1 == 10% off). null == no discount.
    double? discountRate,

    /// May this partner defer payment?
    @Default(false) bool allowDeferred,

    /// Balance due this many days BEFORE the tour date.
    @Default(0) int deferredDays,

    /// Never delete partners — archive for stats/recovery.
    @Default(false) bool archived,
  }) = _Partner;

  factory Partner.fromJson(Map<String, dynamic> json) =>
      _$PartnerFromJson(json);
}

extension PartnersExtension on List<Partner> {
  /// Non-archived partners only.
  List<Partner> get active => where((p) => !p.archived).toList();

  /// First partner with this id, or null.
  Partner? fromId(String id) => where((p) => p.id == id).firstOrNull;

  /// First NON-ARCHIVED partner whose code matches (case-insensitive), or null.
  Partner? fromCode(String code) => active
      .where((p) => p.code.toLowerCase() == code.trim().toLowerCase())
      .firstOrNull;
}
