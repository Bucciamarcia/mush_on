import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// A converter to handle the conversion between Firestore's Timestamp and Dart's DateTime.
class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  // This is called when reading data from Firestore (Timestamp -> DateTime).
  @override
  DateTime? fromJson(Timestamp? timestamp) {
    return timestamp?.toDate();
  }

  // This is called when writing data to Firestore (DateTime -> Timestamp).
  @override
  Timestamp? toJson(DateTime? date) =>
      date == null ? null : Timestamp.fromDate(date);
}

/// A converter to handle non-nullable DateTime and Timestamp.
class NonNullableTimestampConverter
    implements JsonConverter<DateTime, Timestamp> {
  const NonNullableTimestampConverter();
  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();
  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

/// A converter to handle lists of Timestamps and DateTimes.
class TimestampListConverter
    implements JsonConverter<List<DateTime>, List<dynamic>> {
  const TimestampListConverter();

  // This is called when reading data from Firestore.
  // Firestore will give us a List of Timestamps.
  @override
  List<DateTime> fromJson(List<dynamic> json) {
    // We map over the list, convert each Timestamp to a DateTime, and return a new list.
    return json.map((timestamp) => (timestamp as Timestamp).toDate()).toList();
  }

  // This is called when writing data to Firestore.
  // We receive a List of DateTimes.
  @override
  List<Timestamp> toJson(List<DateTime> dates) {
    // We map over the list, convert each DateTime to a Timestamp, and return a new list.
    return dates.map((date) => Timestamp.fromDate(date)).toList();
  }
}

/// Converts a non-nullable Timestamp from Firestore to a DateTime
DateTime nonNullableDateFromTimestamp(Timestamp timestamp) =>
    timestamp.toDate();

/// Converts a non-nullable DateTime from your app to a Timestamp for Firestore
Timestamp nonNullableDateToTimestamp(DateTime date) => Timestamp.fromDate(date);
