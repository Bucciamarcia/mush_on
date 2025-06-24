import 'package:flutter/material.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';

class SingleWarningDisplayWidget extends StatefulWidget {
  final DistanceWarning warning;
  final Function(String) onDistanceWarningRemoved;
  final Function(DistanceWarning) onDistanceWarningEdited;

  const SingleWarningDisplayWidget(this.warning,
      {super.key,
      required this.onDistanceWarningRemoved,
      required this.onDistanceWarningEdited});

  @override
  State<SingleWarningDisplayWidget> createState() =>
      _SingleWarningDisplayWidgetState();
}

class _SingleWarningDisplayWidgetState
    extends State<SingleWarningDisplayWidget> {
  late TextEditingController _daysController;
  late TextEditingController _distanceController;
  late DistanceWarningType _selectedType;
  late DistanceWarning _originalWarning;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _originalWarning = widget.warning;
    _resetControllers();
  }

  void _resetControllers() {
    _daysController =
        TextEditingController(text: widget.warning.daysInterval.toString());
    _distanceController =
        TextEditingController(text: widget.warning.distance.toString());
    _selectedType = widget.warning.distanceWarningType;
  }

  @override
  void dispose() {
    _daysController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  void _save() {
    final edited = widget.warning.copyWith(
      daysInterval:
          int.tryParse(_daysController.text) ?? widget.warning.daysInterval,
      distance:
          int.tryParse(_distanceController.text) ?? widget.warning.distance,
      distanceWarningType: _selectedType,
    );
    widget.onDistanceWarningEdited(edited);
    setState(() {
      _isEditing = false;
      _originalWarning = edited;
    });
  }

  void _revert() {
    setState(() {
      _daysController.text = _originalWarning.daysInterval.toString();
      _distanceController.text = _originalWarning.distance.toString();
      _selectedType = _originalWarning.distanceWarningType;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _selectedType == DistanceWarningType.hard
          ? Colors.red.shade50
          : Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _distanceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Distance (km)',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                          ),
                          onChanged: (_) => setState(() => _isEditing = true),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _daysController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Days',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                          ),
                          onChanged: (_) => setState(() => _isEditing = true),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<DistanceWarningType>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: 'Type',
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    items: DistanceWarningType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                        _isEditing = true;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isEditing) ...[
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: _save,
                    tooltip: 'Save',
                  ),
                  IconButton(
                    icon: Icon(Icons.undo, color: Colors.orange),
                    onPressed: _revert,
                    tooltip: 'Revert',
                  ),
                ],
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      widget.onDistanceWarningRemoved(widget.warning.id),
                  tooltip: 'Remove',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
