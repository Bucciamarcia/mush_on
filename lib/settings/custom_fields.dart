import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/settings/add_template_button.dart';
import 'package:mush_on/settings/section_shell.dart';

class CustomFieldsOptions extends StatelessWidget {
  final List<CustomFieldTemplate> customFieldTemplates;
  final Function(CustomFieldTemplate) onCustomFieldAdded;
  final Function(String) onCustomFieldDeleted;
  const CustomFieldsOptions(
      {super.key,
      required this.customFieldTemplates,
      required this.onCustomFieldAdded,
      required this.onCustomFieldDeleted});

  @override
  Widget build(BuildContext context) {
    return SettingsSectionShell(
      title: "Custom fields",
      description:
          "Manage the reusable fields available across your account and keep the setup consistent for your team.",
      badge: "Account setup",
      child: SettingsSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    "${customFieldTemplates.length} template${customFieldTemplates.length == 1 ? '' : 's'}",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Text(
                  "These templates are used whenever you add custom fields to forms.",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (customFieldTemplates.isNotEmpty)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: customFieldTemplates
                    .map((t) => CustomFieldTemplateCard(
                          template: t,
                          onCustomFieldDeleted: () =>
                              onCustomFieldDeleted(t.id),
                        ))
                    .toList(),
              )
            else
              _EmptyCustomFieldsState(
                onPressed: () {},
              ),
            const SizedBox(height: 20),
            AddTemplateButton(
              onCustomFieldAdded: (cf) => onCustomFieldAdded(cf),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCustomFieldsState extends StatelessWidget {
  final VoidCallback onPressed;

  const _EmptyCustomFieldsState({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.tune_rounded,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            "No templates yet",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            "Create the first field to standardize extra information collected across the account.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class CustomFieldTemplateCard extends StatelessWidget {
  static final BasicLogger logger = BasicLogger();
  final CustomFieldTemplate template;
  final Function() onCustomFieldDeleted;
  const CustomFieldTemplateCard(
      {super.key, required this.template, required this.onCustomFieldDeleted});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 180, maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  template.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  template.type.showToUser,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => onCustomFieldDeleted(),
            icon: const Icon(Icons.cancel),
            tooltip: "Delete template",
            color: colorScheme.onSurfaceVariant,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
