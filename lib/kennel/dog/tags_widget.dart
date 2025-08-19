import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:searchfield/searchfield.dart';
import 'package:uuid/uuid.dart';

class TagsWidget extends StatelessWidget {
  static BasicLogger logger = BasicLogger();
  final List<Tag> tags;
  final List<Tag> allTags;
  final Function(Tag) onTagAdded;
  final Function(Tag) onTagDeleted;
  final Function(Tag) onTagChanged;
  const TagsWidget(
      {super.key,
      required this.tags,
      required this.onTagAdded,
      required this.onTagDeleted,
      required this.allTags,
      required this.onTagChanged});

  static List<Tag> _getValidTags(List<Tag> tags) {
    List<Tag> toReturn = [];
    for (Tag tag in tags) {
      if (tag.expired == null) {
        toReturn.add(tag);
      } else {
        if (tag.expired!.toUtc().isAfter(DateTime.now().toUtc())) {
          toReturn.add(tag);
        }
      }
    }
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    List<Tag> validTags = _getValidTags(tags);
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextTitle("Tags"),
              IconButton.outlined(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => TagEditor(
                              onTagSaved: (newTag) => onTagAdded(newTag),
                              allTags: allTags,
                            ));
                  },
                  icon: const Icon(Icons.add)),
            ],
          ),
          Wrap(
            spacing: 8,
            children: validTags
                .map((Tag tag) => SingleTagDisplay(
                      tag: tag,
                      allTags: allTags,
                      onTagDeleted: () => onTagDeleted(tag),
                      onTagChanged: (Tag newTag) => onTagChanged(newTag),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class TagEditor extends StatefulWidget {
  final Tag? tagToEdit;
  final List<Tag> allTags;
  final Function(Tag) onTagSaved;
  const TagEditor(
      {super.key,
      required this.onTagSaved,
      required this.allTags,
      this.tagToEdit});

  @override
  State<TagEditor> createState() => _TagEditorState();
}

class _TagEditorState extends State<TagEditor> {
  late TextEditingController _controller;
  SearchFieldListItem<Tag>? selectedValue;
  late Color color;
  DateTime? expiration;
  late bool preventsRunning;
  late bool showInTeamBuilder;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: (widget.tagToEdit == null) ? null : widget.tagToEdit!.name);
    color = (widget.tagToEdit == null) ? Colors.green : widget.tagToEdit!.color;
    expiration = (widget.tagToEdit == null) ? null : widget.tagToEdit!.expired;
    preventsRunning =
        (widget.tagToEdit == null) ? false : widget.tagToEdit!.preventFromRun;
    showInTeamBuilder = (widget.tagToEdit == null)
        ? false
        : widget.tagToEdit!.showInTeamBuilder;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text("Add a new tag"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            SearchField<Tag>(
              controller: _controller,
              searchInputDecoration:
                  SearchInputDecoration(hint: const Text("Tag name")),
              suggestions: widget.allTags
                  .map(
                    (e) => SearchFieldListItem<Tag>(e.name, item: e),
                  )
                  .toList(),
              selectedValue: selectedValue,
              onSuggestionTap: (x) {
                setState(() {
                  selectedValue = x;
                });
              },
            ),
            ExpansionTile(
              title: Row(
                spacing: 20,
                children: [
                  ColorIndicator(
                    HSVColor.fromColor(color),
                    height: 25,
                    width: 25,
                  ),
                  const Text("Pick a color"),
                ],
              ),
              children: [
                MaterialPicker(
                    pickerColor: Theme.of(context).colorScheme.primary,
                    onColorChanged: (Color newColor) {
                      setState(() {
                        color = newColor;
                      });
                    })
              ],
            ),
            const Text(
              "Expiration date",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text((expiration != null)
                ? DateFormat("yyyy-MM-dd").format(expiration!)
                : "No expiration set"),
            Wrap(
              children: [
                ElevatedButton(
                  onPressed: () => selectDate(),
                  child: const Text("Select expiration"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      expiration = null;
                    });
                  },
                  child: const Text("Remove expiration"),
                )
              ],
            ),
            CheckboxListTile.adaptive(
              title: const Text("Prevents running"),
              value: preventsRunning,
              onChanged: (v) => {
                setState(() {
                  if (v != null) {
                    preventsRunning = v;
                  }
                })
              },
            ),
            CheckboxListTile.adaptive(
                title: const Text("Show in builder"),
                value: showInTeamBuilder,
                onChanged: (v) {
                  setState(() {
                    if (v != null) {
                      showInTeamBuilder = v;
                    }
                  });
                })
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              widget.onTagSaved(
                Tag(
                  name: _controller.text,
                  color: color,
                  created: (widget.tagToEdit == null)
                      ? DateTime.now().toUtc()
                      : widget.tagToEdit!.created,
                  expired: expiration,
                  id: (widget.tagToEdit == null)
                      ? const Uuid().v4()
                      : widget.tagToEdit!.id,
                  preventFromRun: preventsRunning,
                  showInTeamBuilder: showInTeamBuilder,
                ),
              );
              Navigator.of(context).pop();
            },
            child: const Text("OK")),
      ],
    );
  }

  Future<void> selectDate() async {
    DateTime? newExpiration = await showDatePicker(
        context: context,
        currentDate: expiration,
        firstDate: DateTime.now().toUtc(),
        lastDate: DateTime(2100, 12, 31));
    setState(() {
      if (newExpiration != null) {
        expiration = newExpiration;
      }
    });
  }
}

class SingleTagDisplay extends StatelessWidget {
  final Tag tag;
  final List<Tag> allTags;
  final Function() onTagDeleted;
  final Function(Tag) onTagChanged;
  const SingleTagDisplay(
      {super.key,
      required this.tag,
      required this.onTagDeleted,
      required this.allTags,
      required this.onTagChanged});

  @override
  Widget build(BuildContext context) {
    return InputChip(
      backgroundColor: tag.color,
      label: Text(
        tag.name,
        style: TextStyle(
            color: (tag.color.computeLuminance() > 0.3)
                ? Colors.black
                : Colors.white),
      ),
      onDeleted: () => onTagDeleted(),
      deleteIcon: Icon(Icons.cancel,
          color: (tag.color.computeLuminance() > 0.3)
              ? Colors.black
              : Colors.white),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => TagEditor(
                allTags: allTags,
                tagToEdit: tag,
                onTagSaved: (Tag editedTag) => onTagChanged(editedTag)));
      },
    );
  }
}
