import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'repository.dart';
part 'riverpod.g.dart';

@riverpod
Future<SettingsRepository> settingsRepository(Ref ref) async {
  String account = await ref.watch(accountProvider.future);
  return SettingsRepository(account: account);
}
