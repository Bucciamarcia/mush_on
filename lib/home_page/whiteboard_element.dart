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
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  CircleAvatarWidget(radius: 20, uid: element.author),
                  const SizedBox(width: 8),
                  Text(ref.watch(userNameProvider).value?.name ?? ""),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      element.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    DateFormat("hh:mm:ss").format(element.date),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),

              // Description
              if (element.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  element.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Comments section
              if (comments.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.comment,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Comments (${comments.length})",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...comments.map(
                  (comment) => Padding(
                    padding: const EdgeInsets.only(left: 22, bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatarWidget(radius: 10, uid: comment.author),
                        const SizedBox(width: 8),
                        Text(ref.watch(userNameProvider).value?.name ?? ""),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            comment.comment,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ),
                        Text(
                          DateFormat("hh:mm:ss").format(comment.date),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
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
    return ElevatedButton.icon(
      onPressed: () => showDialog(
        context: context,
        builder: (dialogContext) => WhiteboardElementEditor(
          onSaved: (e) => onSaved(e),
          onDeleted: (id) => onDeleted(id),
        ),
      ),
      label: const Text("Add element"),
      icon: const Icon(Icons.add),
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
