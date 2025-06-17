import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/services/models/notes.dart';
import 'package:uuid/uuid.dart';

class SingleDogNotesWidget extends StatefulWidget {
  final List<SingleDogNote> dogNotes;
  final Function(SingleDogNote) onNoteAdded;
  final Function(String) onNoteDeleted;

  const SingleDogNotesWidget({
    super.key,
    required this.dogNotes,
    required this.onNoteAdded,
    required this.onNoteDeleted,
  });

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
      return b.date!.compareTo(a.date!); // Show newest first
    });

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dog Notes",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (orderedNotes.isEmpty && !_isAddingNote)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text(
                    "No notes for this dog yet.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            if (orderedNotes.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderedNotes.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final note = orderedNotes[index];
                  return SingleDogNoteWidget(
                    key: ValueKey(note.id),
                    note: note,
                    onNoteChanged: (updatedNote) =>
                        widget.onNoteAdded(updatedNote),
                    onNoteDeleted: () => widget.onNoteDeleted(note.id),
                  );
                },
              ),
            const SizedBox(height: 16),
            _isAddingNote
                ? AddSingleNoteWidget(
                    onNoteAdded: (note) {
                      widget.onNoteAdded(note);
                      setState(() {
                        _isAddingNote = false;
                      });
                    },
                    onCancel: () {
                      setState(() {
                        _isAddingNote = false;
                      });
                    },
                  )
                : Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isAddingNote = true;
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add a new note"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class SingleDogNoteWidget extends StatefulWidget {
  final SingleDogNote note;
  final Function() onNoteDeleted;
  final Function(SingleDogNote) onNoteChanged;

  const SingleDogNoteWidget({
    super.key,
    required this.note,
    required this.onNoteDeleted,
    required this.onNoteChanged,
  });

  @override
  State<SingleDogNoteWidget> createState() => _SingleDogNoteWidgetState();
}

class _SingleDogNoteWidgetState extends State<SingleDogNoteWidget> {
  late TextEditingController _controller;
  late bool _hasChanged;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note.content);
    _hasChanged = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date != null) {
      return DateFormat.yMMMd().add_jm().format(date); // More readable format
    } else {
      return "No date";
    }
  }

  void _saveNote(String content) {
    final updatedNote = SingleDogNote(
      id: widget.note.id,
      date: DateTime.now().toUtc(),
      content: content,
    );
    widget.onNoteChanged(updatedNote);
    setState(() {
      _hasChanged = false;
    });
    FocusScope.of(context).unfocus(); // Dismiss keyboard
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(widget.note.date),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              Row(
                children: [
                  IconButton(
                    tooltip: _hasChanged ? "Save changes" : "Note is saved",
                    onPressed:
                        _hasChanged ? () => _saveNote(_controller.text) : null,
                    icon: Icon(
                      _hasChanged ? Icons.save : Icons.check_circle,
                      color: _hasChanged
                          ? Theme.of(context).colorScheme.primary
                          : Colors.green,
                    ),
                  ),
                  IconButton(
                    tooltip: "Delete note",
                    onPressed: widget.onNoteDeleted,
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            minLines: 2,
            maxLines: 5,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(12.0),
            ),
            onChanged: (_) {
              if (!_hasChanged) {
                setState(() {
                  _hasChanged = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

class AddSingleNoteWidget extends StatefulWidget {
  final Function(SingleDogNote) onNoteAdded;
  final VoidCallback onCancel;

  const AddSingleNoteWidget({
    super.key,
    required this.onNoteAdded,
    required this.onCancel,
  });

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
    _controller.dispose();
    super.dispose();
  }

  void _submitNote(String content) {
    if (content.trim().isEmpty) {
      // Optional: show a snackbar or message
      return;
    }
    final newNote = SingleDogNote(
      date: DateTime.now().toUtc(),
      id: const Uuid().v4(),
      content: content,
    );
    widget.onNoteAdded(newNote);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            minLines: 3,
            maxLines: 5,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter new note...",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onCancel,
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _submitNote(_controller.text),
                icon: const Icon(Icons.add_comment),
                label: const Text("Add Note"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
