import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/services/error_handling.dart';
import '../riverpod.dart';
import 'main.dart';

class AddTourScreen extends ConsumerWidget {
  final String? tourId;
  const AddTourScreen({super.key, this.tourId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tourId == null) {
      return TemplateScreen(title: "Tour editor", child: TourEditorMain());
    }
    var tourTypeAsync = ref.watch(tourTypeByIdProvider(tourId!));
    return tourTypeAsync.when(
      data: (data) => TemplateScreen(
          title: "Tour editor", child: TourEditorMain(tour: data)),
      error: (e, s) {
        BasicLogger()
            .error("Failed to load tour type $tourId", error: e, stackTrace: s);
        return TemplateScreen(
            title: "Error",
            child: Center(
              child: Text("Failed to load tour type $tourId"),
            ));
      },
      loading: () => Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
