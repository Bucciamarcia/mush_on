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
            // Improved header with icon and count
            Row(
              children: [
                Icon(
                  Icons.note_alt_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  "Dog Notes",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                // Note count badge
                if (orderedNotes.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      "${orderedNotes.length}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Empty state with icon
            if (orderedNotes.isEmpty && !_isAddingNote)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.note_add_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "No notes for this dog yet",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            if (orderedNotes.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderedNotes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final note = orderedNotes[index];
                  return SingleDogNoteWidget(
                    key: ValueKey(note.id),
                    note: note,
                    isFirst: index == 0,
                    onNoteChanged: (updatedNote) {
                      widget.onNoteDeleted(updatedNote.id);
                      widget.onNoteAdded(updatedNote);
                    },
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
  final bool isFirst;

  const SingleDogNoteWidget({
    super.key,
    required this.note,
    required this.onNoteDeleted,
    required this.onNoteChanged,
    this.isFirst = false,
  });

  @override
  State<SingleDogNoteWidget> createState() => _SingleDogNoteWidgetState();
}

class _SingleDogNoteWidgetState extends State<SingleDogNoteWidget> {
  late TextEditingController _controller;
  late bool _hasChanged;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note.content);
    _hasChanged = false;
    _isEditing = false;
  }

  @override
  void didUpdateWidget(SingleDogNoteWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent widget provides a new note object,
    // update the controller's text to match the new content.
    if (widget.note.content != oldWidget.note.content) {
      _controller.text = widget.note.content;
      // You might want to reset the change indicator as well
      _hasChanged = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date != null) {
      final now = DateTime.now();
      final difference = now.difference(date);

      // Show relative time for recent notes
      if (difference.inMinutes < 60) {
        return "${difference.inMinutes} min ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} hours ago";
      } else if (difference.inDays < 7) {
        return "${difference.inDays} days ago";
      }

      return DateFormat.yMMMd().format(date);
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
      _isEditing = false;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isFirst
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: widget.isFirst
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (widget.isFirst)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Text(
                          "LATEST",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (widget.isFirst) const SizedBox(width: 8),
                    Text(
                      _formatDate(widget.note.date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (_isEditing)
                      IconButton(
                        tooltip: _hasChanged ? "Save changes" : "Note is saved",
                        onPressed: _hasChanged
                            ? () => _saveNote(_controller.text)
                            : null,
                        icon: Icon(
                          _hasChanged ? Icons.save : Icons.check_circle,
                          color: _hasChanged
                              ? Theme.of(context).colorScheme.primary
                              : Colors.green,
                          size: 20,
                        ),
                      )
                    else
                      IconButton(
                        tooltip: "Edit note",
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    IconButton(
                      tooltip: "Delete note",
                      onPressed: () {
                        // Add confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Note"),
                            content: const Text(
                                "Are you sure you want to delete this note?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.onNoteDeleted();
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_isEditing)
              TextField(
                controller: _controller,
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey[300]!),
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
              )
            else
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    widget.note.content,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
          ],
        ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a note"),
          duration: Duration(seconds: 2),
        ),
      );
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
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
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
