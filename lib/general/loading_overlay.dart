import 'package:flutter/material.dart';

class LoadingOverlay {
  static OverlayEntry? _overlayEntry;

  /// Shows the loading overlay. Call this before starting an async operation.
  /// Example: `LoadingOverlay.show(context);`
  static void show(BuildContext context) {
    // Prevent multiple overlays from stacking
    if (_overlayEntry != null) return;

    // Create the overlay entry with a dark background and a loading indicator
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Semi-transparent black background to block interaction
          ModalBarrier(dismissible: false, color: Colors.black54),
          // Centered loading indicator
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );

    // Insert the overlay into the widget tree
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Hides the loading overlay. Call this after the async operation completes.
  /// Example: `LoadingOverlay.hide();`
  static void hide() {
    // Remove the overlay if it exists
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
