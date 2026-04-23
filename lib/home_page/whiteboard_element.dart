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
  const WhiteboardElementDisplayWidget({
    super.key,
    required this.element,
    required this.onSaved,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
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
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatarWidget(radius: 16, uid: element.author),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            ref.watch(userNameProvider(null)).value?.name ??
                                "Unknown",
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.onSurface,
                            ),
                          ),
                          Text(
                            DateFormat("MMM d, HH:mm").format(element.date),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: colors.outlineVariant.withValues(alpha: 0.8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (element.title.isNotEmpty)
                              Text(
                                element.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            if (element.title.isNotEmpty &&
                                element.description.isNotEmpty)
                              const SizedBox(height: 6),
                            if (element.description.isNotEmpty)
                              Text(
                                element.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  height: 1.35,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (comments.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${comments.length} ${comments.length == 1 ? 'comment' : 'comments'}",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...comments
                        .take(2)
                        .map(
                          (comment) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatarWidget(
                                  radius: 11,
                                  uid: comment.author,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ref
                                                .watch(userNameProvider(null))
                                                .value
                                                ?.name ??
                                            "Unknown",
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: colors.onSurface,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        comment.comment,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: colors.onSurfaceVariant,
                                              height: 1.3,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat("HH:mm").format(comment.date),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colors.onSurfaceVariant,
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
    );
  }
}

class AddWhiteboardElementDisplayWidget extends StatelessWidget {
  final Function(WhiteboardElement) onSaved;
  final Function(String) onDeleted;
  const AddWhiteboardElementDisplayWidget({
    super.key,
    required this.onSaved,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (dialogContext) => WhiteboardElementEditor(
          onSaved: (e) => onSaved(e),
          onDeleted: (id) => onDeleted(id),
        ),
      ),
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: theme.colorScheme.primary, size: 18),
            const SizedBox(width: 6),
            Text(
              "Add note",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WhiteboardElementEditor extends ConsumerStatefulWidget {
  final WhiteboardElement? element;
  final Function(WhiteboardElement) onSaved;
  final Function(String) onDeleted;
  const WhiteboardElementEditor({
    super.key,
    this.element,
    required this.onSaved,
    required this.onDeleted,
  });

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
    _descriptionController = TextEditingController(
      text: widget.element?.description,
    );
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
            UserName? user = await ref.watch(userNameProvider(null).future);
            if (_formKey.currentState!.validate()) {
              List<WhiteboardElementComment> constComments = [];
              constComments.addAll(
                widget.element?.comments ?? <WhiteboardElementComment>[],
              );
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
              if (!mounted) {
                return;
              }
              Navigator.of(this.context).pop();
            }
          },
          icon: const Icon(Icons.save),
          label: const Text("Save"),
        ),
      ],
    );
  }
}
