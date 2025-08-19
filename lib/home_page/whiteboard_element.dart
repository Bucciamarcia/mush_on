import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/home_page/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models/username.dart';
import 'package:mush_on/shared/circle_avatar/circle_avatar.dart';
import 'package:uuid/uuid.dart';

class WhiteboardElementDisplayWidget extends ConsumerWidget {
  final WhiteboardElement element;
  final Function(WhiteboardElement) onSaved;
  final Function(String) onDeleted;
  const WhiteboardElementDisplayWidget(
      {super.key,
      required this.element,
      required this.onSaved,
      required this.onDeleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<WhiteboardElementComment> comments = List.from(element.comments);
    comments.sort((a, b) => a.date.compareTo(b.date));
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (dialogContext) => WhiteboardElementEditor(
          onSaved: (e) => onSaved(e),
          onDeleted: (id) => onDeleted(id),
          element: element,
        ),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with avatar, name, and timestamp
              Row(
                children: [
                  CircleAvatarWidget(radius: 18, uid: element.author),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ref.watch(userNameProvider).value?.name ?? "Unknown",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat("MMM d, HH:mm").format(element.date),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Title
              Text(
                element.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Description
              if (element.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  element.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Comments section
              if (comments.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${comments.length} ${comments.length == 1 ? 'comment' : 'comments'}",
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...comments.map(
                        (comment) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatarWidget(radius: 12, uid: comment.author),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          ref.watch(userNameProvider).value?.name ?? "Unknown",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).colorScheme.onSurface,
                                              ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          DateFormat("HH:mm").format(comment.date),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                                fontSize: 11,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      comment.comment,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            height: 1.3,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AddWhiteboardElementDisplayWidget extends StatelessWidget {
  final Function(WhiteboardElement) onSaved;
  final Function(String) onDeleted;
  const AddWhiteboardElementDisplayWidget(
      {super.key, required this.onSaved, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (dialogContext) => WhiteboardElementEditor(
            onSaved: (e) => onSaved(e),
            onDeleted: (id) => onDeleted(id),
          ),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Add new note",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WhiteboardElementEditor extends ConsumerStatefulWidget {
  final WhiteboardElement? element;
  final Function(WhiteboardElement) onSaved;
  final Function(String) onDeleted;
  const WhiteboardElementEditor(
      {super.key,
      this.element,
      required this.onSaved,
      required this.onDeleted});

  @override
  ConsumerState<WhiteboardElementEditor> createState() =>
      _WhiteboardElementEditorState();
}

class _WhiteboardElementEditorState
    extends ConsumerState<WhiteboardElementEditor> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _addCommentController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.element?.title);
    _descriptionController =
        TextEditingController(text: widget.element?.description);
    _addCommentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      title: Text(
        widget.element == null ? "Add Element" : "Edit Element",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Enter a title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                hintText: "Enter a description (optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addCommentController,
              decoration: InputDecoration(
                labelText: "Add Comment",
                hintText: "Enter a comment (optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.comment),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        if (widget.element != null)
          TextButton.icon(
            onPressed: () {
              widget.onDeleted(widget.element!.id);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete),
            label: const Text("Delete"),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () async {
            UserName? user = await ref.watch(userNameProvider.future);
            if (_formKey.currentState!.validate()) {
              List<WhiteboardElementComment> constComments = [];
              constComments.addAll(
                  widget.element?.comments ?? <WhiteboardElementComment>[]);
              if (_addCommentController.text.trim().isNotEmpty) {
                constComments.add(
                  WhiteboardElementComment(
                    comment: _addCommentController.text.trim(),
                    author: user?.uid,
                    date: DateTime.now(),
                  ),
                );
              }
              widget.onSaved(
                WhiteboardElement(
                  id: widget.element?.id ?? const Uuid().v4(),
                  title: _titleController.text.trim(),
                  date: widget.element?.date ?? DateTime.now(),
                  author: user?.uid,
                  comments: constComments,
                  description: _descriptionController.text.trim(),
                ),
              );
              Navigator.of(context).pop();
            }
          },
          icon: const Icon(Icons.save),
          label: const Text("Save"),
        ),
      ],
    );
  }
}
