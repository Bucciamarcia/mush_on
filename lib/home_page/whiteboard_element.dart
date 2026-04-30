import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/home_page/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models/username.dart';
import 'package:mush_on/shared/circle_avatar/circle_avatar.dart';
import 'package:uuid/uuid.dart';

const whiteboardCategories = [
  "General",
  "Dogs",
  "Equipment",
  "Tours",
  "Maintenance",
];

int compareWhiteboardElements(WhiteboardElement a, WhiteboardElement b) {
  if (a.isPinned != b.isPinned) {
    return a.isPinned ? -1 : 1;
  }
  if (a.isDone != b.isDone) {
    return a.isDone ? 1 : -1;
  }
  return b.activityDate.compareTo(a.activityDate);
}

class WhiteboardElementDisplayWidget extends ConsumerStatefulWidget {
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
  ConsumerState<WhiteboardElementDisplayWidget> createState() =>
      _WhiteboardElementDisplayWidgetState();
}

class _WhiteboardElementDisplayWidgetState
    extends ConsumerState<WhiteboardElementDisplayWidget> {
  bool _showOlderComments = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    List<WhiteboardElementComment> comments = List.from(
      widget.element.comments,
    );
    comments.sort((a, b) => a.date.compareTo(b.date));
    final olderCommentCount = comments.length > 3 ? comments.length - 3 : 0;
    final visibleComments = _showOlderComments || comments.length <= 3
        ? comments
        : comments.sublist(comments.length - 3);
    final isDone = widget.element.isDone;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDone
            ? colors.surfaceContainerLowest
            : widget.element.isPinned
            ? colors.primaryContainer.withValues(alpha: 0.28)
            : colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.element.isPinned
              ? colors.primary.withValues(alpha: 0.45)
              : colors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AuthorAvatar(radius: 16, uid: widget.element.author),
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
                        if (widget.element.isPinned)
                          Icon(Icons.push_pin, size: 16, color: colors.primary),
                        _UserNameText(
                          uid: widget.element.author,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: widget.element.isPinned
                                ? FontWeight.w800
                                : FontWeight.w700,
                            color: isDone
                                ? colors.onSurfaceVariant
                                : colors.onSurface,
                          ),
                        ),
                        _CategoryChip(category: widget.element.category),
                        if (isDone)
                          _StatusChip(
                            label: "Done",
                            icon: Icons.check_circle,
                            color: colors.outline,
                          ),
                        Text(
                          DateFormat(
                            "MMM d, HH:mm",
                          ).format(widget.element.activityDate),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
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
                          if (widget.element.title.isNotEmpty)
                            Text(
                              widget.element.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: isDone
                                    ? colors.onSurfaceVariant
                                    : colors.onSurface,
                                fontWeight: widget.element.isPinned
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          if (widget.element.title.isNotEmpty &&
                              widget.element.description.isNotEmpty)
                            const SizedBox(height: 6),
                          if (widget.element.description.isNotEmpty)
                            Text(
                              widget.element.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                                height: 1.35,
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: widget.element.isPinned ? "Unpin note" : "Pin note",
                icon: Icon(
                  widget.element.isPinned
                      ? Icons.push_pin
                      : Icons.push_pin_outlined,
                ),
                onPressed: () => widget.onSaved(
                  widget.element.copyWith(
                    isPinned: !widget.element.isPinned,
                    lastActivityAt: DateTime.now(),
                  ),
                ),
              ),
              IconButton(
                tooltip: isDone ? "Mark open" : "Mark done",
                icon: Icon(
                  isDone
                      ? Icons.radio_button_unchecked
                      : Icons.check_circle_outline,
                ),
                onPressed: () => widget.onSaved(
                  widget.element.copyWith(
                    isDone: !widget.element.isDone,
                    lastActivityAt: DateTime.now(),
                  ),
                ),
              ),
              IconButton(
                tooltip: "Edit note",
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => showDialog(
                  context: context,
                  builder: (dialogContext) => WhiteboardElementEditor(
                    onSaved: (e) => widget.onSaved(e),
                    onDeleted: (id) => widget.onDeleted(id),
                    element: widget.element,
                  ),
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
                  if (olderCommentCount > 0 && !_showOlderComments) ...[
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () =>
                          setState(() => _showOlderComments = true),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 28),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text("Show older comments ($olderCommentCount)"),
                    ),
                  ],
                  const SizedBox(height: 10),
                  ...visibleComments.map(
                    (comment) => _WhiteboardCommentRow(comment: comment),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          _QuickCommentField(
            onCommentSaved: (comment) {
              widget.onSaved(
                widget.element.copyWith(
                  comments: [...widget.element.comments, comment],
                  lastActivityAt: DateTime.now(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _UserNameText extends ConsumerWidget {
  final String? uid;
  final TextStyle? style;
  const _UserNameText({required this.uid, this.style});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (uid == null) {
      return Text("Unknown", style: style);
    }
    return Text(
      ref.watch(userNameProvider(uid)).value?.name ?? "Unknown",
      style: style,
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;
  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return _StatusChip(
      label: whiteboardCategories.contains(category) ? category : "General",
      icon: Icons.label_outline,
      color: colors.primary,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _StatusChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthorAvatar extends StatelessWidget {
  final String? uid;
  final double radius;
  const _AuthorAvatar({required this.uid, required this.radius});

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return CircleAvatar(
        radius: radius,
        child: Icon(Icons.person, size: radius),
      );
    }
    return CircleAvatarWidget(radius: radius, uid: uid);
  }
}

class _WhiteboardCommentRow extends StatelessWidget {
  final WhiteboardElementComment comment;
  const _WhiteboardCommentRow({required this.comment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AuthorAvatar(radius: 11, uid: comment.author),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _UserNameText(
                  uid: comment.author,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  comment.comment,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            DateFormat("MMM d, HH:mm").format(comment.date),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCommentField extends ConsumerStatefulWidget {
  final Function(WhiteboardElementComment) onCommentSaved;
  const _QuickCommentField({required this.onCommentSaved});

  @override
  ConsumerState<_QuickCommentField> createState() => _QuickCommentFieldState();
}

class _QuickCommentFieldState extends ConsumerState<_QuickCommentField> {
  late final TextEditingController _controller;

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

  Future<void> _saveComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final user = await ref.read(userNameProvider(null).future);
    widget.onCommentSaved(
      WhiteboardElementComment(
        comment: text,
        author: user?.uid,
        date: DateTime.now(),
      ),
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      minLines: 1,
      maxLines: 3,
      textInputAction: TextInputAction.send,
      onSubmitted: (_) => _saveComment(),
      decoration: InputDecoration(
        hintText: "Add a comment",
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          tooltip: "Add comment",
          icon: const Icon(Icons.send),
          onPressed: _saveComment,
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
  late String _category;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.element?.title);
    _descriptionController = TextEditingController(
      text: widget.element?.description,
    );
    final category = widget.element?.category ?? "General";
    _category = whiteboardCategories.contains(category) ? category : "General";
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      title: Text(
        widget.element == null ? "Add note" : "Edit note",
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
                labelText: "Note",
                hintText: "Write the note",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.note_alt_outlined),
              ),
              validator: (value) {
                final title = value?.trim() ?? "";
                final description = _descriptionController.text.trim();
                if (title.isEmpty && description.isEmpty) {
                  return 'Write a note or details';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Details",
                hintText: "Add details (optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.label_outline),
              ),
              items: whiteboardCategories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _category = value);
                }
              },
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
              final now = DateTime.now();
              widget.onSaved(
                WhiteboardElement(
                  id: widget.element?.id ?? const Uuid().v4(),
                  title: _titleController.text.trim(),
                  date: widget.element?.date ?? now,
                  lastActivityAt: now,
                  category: _category,
                  isDone: widget.element?.isDone ?? false,
                  isPinned: widget.element?.isPinned ?? false,
                  author: widget.element?.author ?? user?.uid,
                  comments:
                      widget.element?.comments ?? <WhiteboardElementComment>[],
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
