import 'package:flutter/material.dart';

import 'glass_toast_widget.dart';
import 'toast_type.dart';

export 'glass_toast_widget.dart';
export 'toast_type.dart';

/// A reusable premium glassmorphic notification overlay controller.
class GlassToast {
  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required ToastType type,
    required String title,
    String? description,
    Duration duration = const Duration(milliseconds: 3200),
  }) {
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = Overlay.of(context, rootOverlay: true);

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => GlassToastWidget(
        type: type,
        title: title,
        description: description,
        duration: duration,
        onDismiss: () {
          if (_currentEntry == entry) {
            entry.remove();
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }
}
