import 'package:flutter/material.dart';
import 'package:mush_on/edit_kennel/dog/main.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:uuid/uuid.dart';

class TagsWidget extends StatelessWidget {
  static BasicLogger logger = BasicLogger();
  final List<Tag> tags;
  final Function(List<Tag>) onTagsChanged;
  final Function(Tag) onTagAdded;
  final Function(Tag) onTagDeleted;
  const TagsWidget(
      {super.key,
      required this.tags,
      required this.onTagsChanged,
      required this.onTagAdded,
      required this.onTagDeleted});

  @override
  Widget build(BuildContext context) {
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
                        builder: (context) => EditTagsDialog());
                  },
                  icon: Icon(Icons.edit)),
              IconButton.outlined(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AddTagDialog(
                              onTagAdded: (newTag) => onTagAdded(newTag),
                            ));
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
          Wrap(
            spacing: 8,
            children: tags
                .map((Tag tag) => SingleTagDisplay(
                      tag: tag,
                      onTagDeleted: () => onTagDeleted(tag),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class EditTagsDialog extends StatelessWidget {
  const EditTagsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Placeholder(),
    );
  }
}

class AddTagDialog extends StatefulWidget {
  final Function(Tag) onTagAdded;
  const AddTagDialog({super.key, required this.onTagAdded});

  @override
  State<AddTagDialog> createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text("Add a new tag"),
      content: TextField(controller: _controller),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")),
        TextButton(
            onPressed: () {
              widget.onTagAdded(
                Tag(
                  name: _controller.text,
                  created: DateTime.now().toUtc(),
                  id: Uuid().v4(),
                ),
              );
              Navigator.of(context).pop();
            },
            child: Text("OK")),
      ],
    );
  }
}

class SingleTagDisplay extends StatelessWidget {
  final Tag tag;
  final Function() onTagDeleted;
  const SingleTagDisplay(
      {super.key, required this.tag, required this.onTagDeleted});

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(tag.name),
      onDeleted: () => onTagDeleted(),
    );
  }
}
