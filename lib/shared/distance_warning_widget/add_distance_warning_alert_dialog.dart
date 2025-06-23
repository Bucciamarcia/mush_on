import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:uuid/uuid.dart';

class AddDistanceWarningAlertDialog extends StatefulWidget {
  final Function(DistanceWarning) onDistanceWarningAdded;
  const AddDistanceWarningAlertDialog(
      {super.key, required this.onDistanceWarningAdded});

  @override
  State<AddDistanceWarningAlertDialog> createState() =>
      _AddDistanceWarningAlertDialogState();
}

class _AddDistanceWarningAlertDialogState
    extends State<AddDistanceWarningAlertDialog> {
  late TextEditingController _distanceController;
  late TextEditingController _daysIntervalController;
  late DistanceWarningType _selectedType;

  @override
  void initState() {
    super.initState();
    _distanceController = TextEditingController();
    _daysIntervalController = TextEditingController();
    _selectedType = DistanceWarningType.soft;
    _distanceController.addListener(_updateButtonState);
    _daysIntervalController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _distanceController.removeListener(_updateButtonState);
    _daysIntervalController.removeListener(_updateButtonState);
    _distanceController.dispose();
    _daysIntervalController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog.adaptive(
      title: Row(
        spacing: 5,
        children: [
          Icon(Icons.warning_amber_rounded, color: theme.colorScheme.primary),
          Text("Add Warning"),
        ],
      ),
      content: SizedBox(
        width: double.minPositive,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _distanceController,
              decoration: InputDecoration(
                labelText: "Maximum distance",
                hintText: "e.g., 100",
                suffixText: "km",
                prefixIcon: Icon(Icons.straighten),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _daysIntervalController,
              decoration: InputDecoration(
                labelText: "Time period",
                hintText: "e.g., 7",
                suffixText: "days",
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Warning type selector with visual indicators
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Warning type", style: theme.textTheme.labelMedium),
                  SizedBox(height: 8),
                  SegmentedButton<DistanceWarningType>(
                    segments: [
                      ButtonSegment(
                        value: DistanceWarningType.soft,
                        label: Text("Soft"),
                        icon: Icon(Icons.info_outline, size: 18),
                        tooltip: "Shows warning but allows selection",
                      ),
                      ButtonSegment(
                        value: DistanceWarningType.hard,
                        label: Text("Hard"),
                        icon: Icon(Icons.block, size: 18),
                        tooltip: "Blocks dog from being selected",
                      ),
                    ],
                    selected: {_selectedType},
                    onSelectionChanged: (Set<DistanceWarningType> selected) {
                      setState(() {
                        _selectedType = selected.first;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (_isButtonActive()) ...[
              SizedBox(height: 12),
              // Preview of what will be created
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 16, color: theme.colorScheme.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${_selectedType == DistanceWarningType.soft ? 'Warn' : 'Block'} if dog runs more than ${_distanceController.text}km in ${_daysIntervalController.text} days",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        FilledButton(
          onPressed: _isButtonActive()
              ? () {
                  widget.onDistanceWarningAdded(DistanceWarning(
                    id: Uuid().v4(),
                    distance: int.parse(_distanceController.text),
                    daysInterval: int.parse(_daysIntervalController.text),
                    distanceWarningType: _selectedType,
                  ));
                  Navigator.of(context).pop();
                }
              : null,
          child: Text("Add Warning"),
        ),
      ],
    );
  }

  bool _isButtonActive() {
    if (_distanceController.text.isEmpty ||
        _daysIntervalController.text.isEmpty) {
      return false;
    }

    final distance = int.tryParse(_distanceController.text) ?? 0;
    final days = int.tryParse(_daysIntervalController.text) ?? 0;

    return distance > 0 && days > 0;
  }
}
