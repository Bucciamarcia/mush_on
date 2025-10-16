import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod
class IsRefundProcessing extends _$IsRefundProcessing {
  @override
  bool build() {
    return false;
  }

  void change(bool v) {
    state = v;
  }
}
