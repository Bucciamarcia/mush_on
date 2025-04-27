import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/edit_kennel/dog/main.dart';
import 'package:mush_on/firestore_dogs_to_id.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:uuid/uuid.dart';

class TagsWidget extends StatelessWidget {
  static BasicLogger logger = BasicLogger();
  final List<Tag> tags;
  final Function(Tag) onTagAdded;
  final Function(Tag) onTagDeleted;
  final Function(Tag) onTagChanged;
  const TagsWidget(
      {super.key,
      required this.tags,
      required this.onTagAdded,
      required this.onTagDeleted,
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
              TextTitle("Tags"),
              IconButton.outlined(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => TagEditor(
                              onTagSaved: (newTag) => onTagAdded(newTag),
                            ));
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
          Wrap(
            spacing: 8,
            children: validTags
                .map((Tag tag) => SingleTagDisplay(
                      tag: tag,
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
  final Function(Tag) onTagSaved;
  const TagEditor({super.key, required this.onTagSaved, this.tagToEdit});

  @override
  State<TagEditor> createState() => _TagEditorState();
}

class _TagEditorState extends State<TagEditor> {
  late TextEditingController _controller;
  late Color color;
  DateTime? expiration;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: (widget.tagToEdit == null) ? null : widget.tagToEdit!.name);
    color = (widget.tagToEdit == null) ? Colors.green : widget.tagToEdit!.color;
    expiration = (widget.tagToEdit == null) ? null : widget.tagToEdit!.expired;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text("Add a new tag"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(labelText: "Tag name"),
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
                  Text("Pick a color"),
                ],
              ),
              children: [
                MaterialPicker(
                    pickerColor: Colors.green,
                    onColorChanged: (Color newColor) {
                      setState(() {
                        color = newColor;
                      });
                    })
              ],
            ),
            Text(
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
                  child: Text("Select expiration"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      expiration = null;
                    });
                  },
                  child: Text("Remove expiration"),
                )
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")),
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
                      ? Uuid().v4()
                      : widget.tagToEdit!.id,
                ),
              );
              Navigator.of(context).pop();
            },
            child: Text("OK")),
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
  final Function() onTagDeleted;
  final Function(Tag) onTagChanged;
  const SingleTagDisplay(
      {super.key,
      required this.tag,
      required this.onTagDeleted,
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
        logger.info("no moi");
        showDialog(
            context: context,
            builder: (context) => TagEditor(
                tagToEdit: tag,
                onTagSaved: (Tag editedTag) => onTagChanged(editedTag)));
      },
    );
  }
}
