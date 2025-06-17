import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/services/models/notes.dart';
import 'package:uuid/uuid.dart';

class SingleDogNotesWidget extends StatefulWidget {
  final List<SingleDogNote> dogNotes;
  final Function(SingleDogNote) onNoteAdded;
  final Function(String) onNoteDeleted;
  const SingleDogNotesWidget(
      {super.key,
      required this.dogNotes,
      required this.onNoteAdded,
      required this.onNoteDeleted});

  @override
  State<SingleDogNotesWidget> createState() => _SingleDogNotesWidgetState();
}

class _SingleDogNotesWidgetState extends State<SingleDogNotesWidget> {
  late bool _isAddingNote;
  @override
  void initState() {
    super.initState();
    _isAddingNote = false;
  }

  @override
  Widget build(BuildContext context) {
    List<SingleDogNote> orderedNotes = List.from(widget.dogNotes);
    orderedNotes.sort((a, b) {
      if (a.date == null) return 1;
      if (b.date == null) return -1;
      return a.date!.compareTo(b.date!);
    });
    return Card(
      child: Column(
        spacing: 5,
        children: [
          orderedNotes.isEmpty
              ? Text("Dog has no notes. Add one below!")
              : Column(
                  spacing: 10,
                  children: [
                    ...orderedNotes.map(
                      (note) => SingleDogNoteWidget(
                        note: note,
                        onNoteChanged: (note) => widget.onNoteAdded(note),
                        onNoteDeleted: () => widget.onNoteDeleted(note.id),
                      ),
                    ),
                  ],
                ),
          _isAddingNote
              ? AddSingleNoteWidget(
                  onNoteAdded: (note) {
                    widget.onNoteAdded(note);
                    setState(() {
                      _isAddingNote = false;
                    });
                  },
                )
              : ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isAddingNote = true;
                    });
                  },
                  label: Text("Add a new note"),
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
        ],
      ),
    );
  }
}

class SingleDogNoteWidget extends StatefulWidget {
  final SingleDogNote note;
  final Function() onNoteDeleted;
  final Function(SingleDogNote) onNoteChanged;
  const SingleDogNoteWidget(
      {super.key,
      required this.note,
      required this.onNoteDeleted,
      required this.onNoteChanged});

  @override
  State<SingleDogNoteWidget> createState() => _SingleDogNoteWidgetState();
}

class _SingleDogNoteWidgetState extends State<SingleDogNoteWidget> {
  late TextEditingController _controller;

  /// If the note has changed, for activating the save button.
  late bool _hasChanged;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.note.content;
    _hasChanged = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Flexible(
          child: Column(
            spacing: 5,
            children: [
              Text(_formatDate(widget.note.date)),
              TextField(
                controller: _controller,
                minLines: 3,
                maxLines: 3,
                onChanged: (_) {
                  setState(() {
                    _hasChanged = true;
                  });
                },
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: _hasChanged ? "Save this note" : "Note is saved",
          onPressed: () => _hasChanged ? _saveNote(_controller.text) : null,
          icon: Icon(_hasChanged ? Icons.save : Icons.check,
              color: _hasChanged
                  ? Theme.of(context).colorScheme.primary
                  : Colors.green),
        ),
        IconButton(
          tooltip: "Delete note",
          onPressed: () => widget.onNoteDeleted(),
          icon: Icon(Icons.delete),
          color: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date != null) {
      return DateFormat("yyyy-MM-dd").format(date);
    } else {
      return "";
    }
  }

  void _saveNote(String content) {
    widget.onNoteChanged(
      SingleDogNote(
        id: widget.note.id,
        date: DateTime.now().toUtc(),
        content: content,
      ),
    );
    setState(() {
      _hasChanged = false;
    });
  }
}

class AddSingleNoteWidget extends StatefulWidget {
  final Function(SingleDogNote) onNoteAdded;
  const AddSingleNoteWidget({super.key, required this.onNoteAdded});

  @override
  State<AddSingleNoteWidget> createState() => _AddSingleNoteWidgetState();
}

class _AddSingleNoteWidgetState extends State<AddSingleNoteWidget> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Flexible(
          child: TextField(
            controller: _controller,
            minLines: 3,
            maxLines: 3,
          ),
        ),
        IconButton(
          tooltip: "Add note",
          onPressed: () => _formatNewNote(_controller.text),
          icon: Icon(Icons.add),
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  void _formatNewNote(String content) {
    widget.onNoteAdded(
      SingleDogNote(
        date: DateTime.now().toUtc(),
        id: Uuid().v4(),
        content: content,
      ),
    );
  }
}
