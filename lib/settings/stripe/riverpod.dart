import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'package:mush_on/settings/stripe/stripe_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@riverpod
Stream<StripeConnection?> stripeConnection(Ref ref) async* {
  final String account = await ref.watch(accountProvider.future);
  final db = FirebaseFirestore.instance;
  String path = "accounts/$account/integrations/stripe";
  final doc = db.doc(path);
  yield* doc.snapshots().map((snapshot) {
    final data = snapshot.data();
    if (data == null) return null;
    return StripeConnection.fromJson(data);
  });
}

@riverpod
class KennelImage extends _$KennelImage {
  @override
  Future<Uint8List?> build({String? account}) async {
    final logger = BasicLogger();
    logger.debug("KennelImage provider build called with account: $account");
    account ??= await ref.read(accountProvider.future);
    if (account == null) {
      logger.error("No account found for kennel image");
      return null;
    }
    logger.debug("Fetching kennel image for account: $account");
    final data = await StripeRepository(account: account).getKennelImage();
    logger.debug(
      "KennelImage provider returning data: ${data?.length ?? 0} bytes",
    );
    return data;
  }

  void change(Uint8List? newPic) {
    state = AsyncValue.data(newPic);
  }
}

@riverpod
Stream<BookingManagerKennelInfo?> bookingManagerKennelInfo(
  Ref ref, {
  String? account,
}) async* {
  account ??= await ref.watch(accountProvider.future);
  final path = "accounts/$account/data/bookingManager";
  final db = FirebaseFirestore.instance;
  final doc = db.doc(path);
  yield* doc.snapshots().map((snapshot) {
    final data = snapshot.data();
    if (data == null) {
      return null;
    }
    return BookingManagerKennelInfo.fromJson(data);
  });
}

@riverpod
class TempCustomerFields extends _$TempCustomerFields {
  @override
  List<CustomerCustomField> build() {
    return [];
  }

  // Method to initialize the draft from existing data
  void setInitialFields(List<CustomerCustomField> fields) {
    if (state.isEmpty && fields.isNotEmpty) {
      state = fields;
    }
  }

  void addField() {
    state = [
      ...state,
      CustomerCustomField(
        id: const Uuid().v4(),
        type: CustomerCustomFieldType.text,
        name: '',
        description: '',
        isRequired: false,
      ),
    ];
  }

  void removeField(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }

  void updateField(int index, CustomerCustomField updatedField) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updatedField else state[i],
    ];
  }
}

@riverpod
class IsCustomerCustomFieldsEdited extends _$IsCustomerCustomFieldsEdited {
  @override
  bool build() {
    return false;
  }

  void setEdited(bool edited) {
    state = edited;
  }
}

@riverpod
class TempBookingFields extends _$TempBookingFields {
  @override
  List<BookingCustomField> build() {
    return [];
  }

  void setInitialFields(List<BookingCustomField> fields) {
    if (state.isEmpty && fields.isNotEmpty) {
      state = fields;
    }
  }

  void addField() {
    state = [
      ...state,
      BookingCustomField(
        id: const Uuid().v4(),
        type: CustomerCustomFieldType.text,
        name: '',
        description: '',
        isRequired: false,
      ),
    ];
  }

  void removeField(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }

  void updateField(int index, BookingCustomField updatedField) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updatedField else state[i],
    ];
  }
}

@riverpod
class IsBookingCustomFieldsEdited extends _$IsBookingCustomFieldsEdited {
  @override
  bool build() {
    return false;
  }

  void setEdited(bool edited) {
    state = edited;
  }
}

@riverpod
class TempBookingReminders extends _$TempBookingReminders {
  @override
  List<BookingReminder> build() {
    return [];
  }

  void setInitialReminders(List<BookingReminder> reminders) {
    if (state.isEmpty && reminders.isNotEmpty) {
      state = reminders;
    }
  }

  void addReminder() {
    state = [...state, BookingReminder(daysBefore: 1, uid: const Uuid().v4())];
  }

  void removeReminder(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }

  void updateReminder(int index, BookingReminder updated) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updated else state[i],
    ];
  }
}

@riverpod
class IsBookingRemindersEdited extends _$IsBookingRemindersEdited {
  @override
  bool build() => false;

  void setEdited(bool edited) {
    state = edited;
  }
}

@JsonEnum()
enum CustomerCustomFieldType { text, dropdown }

@freezed
sealed class CustomerCustomField with _$CustomerCustomField {
  const factory CustomerCustomField({
    required String id,
    required CustomerCustomFieldType type,
    required String name,
    required String description,
    required bool isRequired,
  }) = _CustomerCustomField;

  factory CustomerCustomField.fromJson(Map<String, dynamic> json) =>
      _$CustomerCustomFieldFromJson(json);
}

@freezed
sealed class BookingCustomField with _$BookingCustomField {
  const factory BookingCustomField({
    required String id,
    required CustomerCustomFieldType type,
    required String name,
    required String description,
    required bool isRequired,
  }) = _BookingCustomField;

  factory BookingCustomField.fromJson(Map<String, dynamic> json) =>
      _$BookingCustomFieldFromJson(json);
}
