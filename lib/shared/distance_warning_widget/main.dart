import 'package:flutter/material.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/shared/distance_warning_widget/add_distance_warning_alert_dialog.dart';

import 'single_warning_display_widget.dart';

class DistanceWarningWidget extends StatelessWidget {
  final List<DistanceWarning> warnings;
  final Function(DistanceWarning) onWarningAdded;
  final Function(DistanceWarning) onWarningEdited;
  final Function(String) onWarningRemoved;
  const DistanceWarningWidget({
    super.key,
    required this.warnings,
    required this.onWarningAdded,
    required this.onWarningEdited,
    required this.onWarningRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text("Add new warning"),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddDistanceWarningAlertDialog(
                    onDistanceWarningAdded: (w) => onWarningAdded(w),
                  );
                });
          },
        ),
        ...warnings.sortByTypeAndDistance().map(
              (w) => SingleWarningDisplayWidget(
                w,
                key: ValueKey(w.id),
                onDistanceWarningRemoved: (id) => onWarningRemoved(id),
                onDistanceWarningEdited: (w) => onWarningEdited(w),
              ),
            )
      ],
    );
  }
}
