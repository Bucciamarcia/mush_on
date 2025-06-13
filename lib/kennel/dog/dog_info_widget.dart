import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/shared/text_title.dart';

class DogInfoWidget extends StatelessWidget {
  static final BasicLogger logger = BasicLogger();
  final String name;
  final DateTime? birthday;
  final DogSex sex;
  final List<CustomField> customFields;
  final Function(DateTime) onBirthdayChanged;
  final Function(DogSex) onSexChanged;
  const DogInfoWidget({
    super.key,
    required this.name,
    required this.sex,
    required this.birthday,
    required this.onBirthdayChanged,
    required this.customFields,
    required this.onSexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        TextTitle("$name's info"),
        Row(
          spacing: 5,
          children: [
            IconButton.outlined(
              onPressed: () async {
                DateTime? datePicked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.utc(1980, 1, 1),
                  lastDate: DateTime.now().toUtc(),
                  initialDate: (birthday == null)
                      ? DateTime.now().toUtc()
                      : DateTime.utc(
                          birthday!.year, birthday!.month, birthday!.day),
                );
                if (datePicked != null) {
                  final selectedUtcDate = DateTime.utc(
                    datePicked.year,
                    datePicked.month,
                    datePicked.day,
                  );
                  onBirthdayChanged(selectedUtcDate);
                }
              },
              icon: Icon(Icons.edit),
            ),
            Expanded(
              child: DogInfoRow(
                "Birthday",
                formatBirth(),
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          spacing: 5,
          children: [
            IconButton.outlined(
              onPressed: () => showAdaptiveDialog(
                  context: context,
                  builder: (BuildContext context) => SexChangeWidget(
                        onSexChanged: (DogSex newSex) => onSexChanged(newSex),
                        currentSex: sex,
                      )),
              icon: Icon(Icons.edit),
            ),
            Expanded(child: DogInfoRow("Sex", getDogSex())),
          ],
        ),
        Divider(),
        DogInfoRow("Age", age != null ? age! : "?"),
      ],
    );
  }

  String? get age {
    if (birthday == null) return null;
    DateTime now = DateTime.now().toUtc();
    if (now.isBefore(birthday!)) {
      BasicLogger().error("Dog birth is in the future");
      throw Exception("Dog birth is in the future");
    }
    final difference = now.difference(birthday!);
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;

    if (years > 0) {
      return "$years year${years > 1 ? 's' : ''}${months > 0 ? ' $months month${months > 1 ? 's' : ''}' : ''}";
    } else {
      return "$months month${months > 1 ? 's' : ''}";
    }
  }

  String formatBirth() {
    if (birthday == null) return "?";
    var u = birthday!.toUtc();
    return DateFormat("yyyy-MM-dd").format(u);
  }

  String getDogSex() {
    if (sex == DogSex.male) return "Male";
    if (sex == DogSex.female) return "Female";
    if (sex == DogSex.none) return "?";
    BasicLogger().error("Dog sex not found");
    throw Exception("Dog sex not Found. This shouldn't happen!");
  }
}

class DogInfoRow extends StatelessWidget {
  final String title;
  final String content;
  const DogInfoRow(this.title, this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18)),
        Text(content, style: TextStyle(fontSize: 18)),
      ],
    );
  }
}

class SexChangeWidget extends StatefulWidget {
  final DogSex currentSex;
  final Function(DogSex) onSexChanged;
  const SexChangeWidget(
      {super.key, required this.currentSex, required this.onSexChanged});

  @override
  State<SexChangeWidget> createState() => _SexChangeWidgetState();
}

class _SexChangeWidgetState extends State<SexChangeWidget> {
  late DogSex? _newSex;

  @override
  void initState() {
    super.initState();
    _newSex = widget.currentSex;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text("Change sex"),
      content: Column(
        children: [
          RadioListTile.adaptive(
              title: Text("Male"),
              value: DogSex.male,
              groupValue: _newSex,
              onChanged: (n) {
                setState(() {
                  _newSex = n;
                });
              }),
          RadioListTile.adaptive(
              title: Text("Female"),
              value: DogSex.female,
              groupValue: _newSex,
              onChanged: (n) {
                setState(() {
                  _newSex = n;
                });
              }),
          RadioListTile.adaptive(
              title: Text("None"),
              value: DogSex.none,
              groupValue: _newSex,
              onChanged: (n) {
                setState(() {
                  _newSex = n;
                });
              })
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")),
        TextButton(
            onPressed: () {
              if (_newSex != null) {
                widget.onSexChanged(_newSex!);
              }
              Navigator.of(context).pop();
            },
            child: Text("OK")),
      ],
    );
  }
}
