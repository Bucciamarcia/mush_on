import 'package:flutter/material.dart';

class CustomThemeOptions {
  /// A ButtonStyle that changes color based on whether it's active,
  /// based on primary color.
  static ButtonStyle responsiveButtonStylePrimary(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.primary.withValues(alpha: 0.4);
          }
          return colorScheme.primary;
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onPrimary.withValues(alpha: 0.4);
          }
          return colorScheme.onPrimary;
        },
      ),
    );
  }
}
