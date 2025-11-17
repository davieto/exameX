import 'package:flutter/material.dart';

class AppPopover extends StatefulWidget {
  final Widget trigger;
  final Widget content;
  final Alignment align;
  const AppPopover({
    super.key,
    required this.trigger,
    required this.content,
    this.align = Alignment.topCenter,
  });

  @override
  State<AppPopover> createState() => _AppPopoverState();
}

class _AppPopoverState extends State<AppPopover> {
  OverlayEntry? _entry;
  final LayerLink _link = LayerLink();

  void _showOverlay(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    _entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Stack(
          children: [
            GestureDetector(
              onTap: _hideOverlay,
              child: Container(color: Colors.transparent),
            ),
            CompositedTransformFollower(
              link: _link,
              offset: const Offset(0, 8),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: color.surface,
                    border: Border.all(color: color.outlineVariant),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: widget.content,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context, debugRequiredFor: widget)?.insert(_entry!);
  }

  void _hideOverlay() {
    _entry?.remove();
    _entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1024) return widget.trigger;
        return CompositedTransformTarget(
          link: _link,
          child: GestureDetector(
            onTap: () {
              if (_entry == null) {
                _showOverlay(context);
              } else {
                _hideOverlay();
              }
            },
            child: widget.trigger,
          ),
        );
      },
    );
  }
}