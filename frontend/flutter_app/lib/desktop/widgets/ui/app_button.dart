import 'package:flutter/material.dart';

enum ButtonVariant { primary, outline, ghost }
enum ButtonSize { sm, md, lg }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.fullWidth = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    double height = switch (widget.size) {
      ButtonSize.sm => 36,
      ButtonSize.md => 42,
      ButtonSize.lg => 48,
    };

    Color baseBg;
    Color textColor;
    Color borderColor;

    switch (widget.variant) {
      case ButtonVariant.primary:
        baseBg = color.primary;
        textColor = color.onPrimary;
        borderColor = Colors.transparent;
        break;
      case ButtonVariant.outline:
        baseBg = Colors.transparent;
        textColor = color.onBackground;
        borderColor = color.outlineVariant;
        break;
      default:
        baseBg = Colors.transparent;
        textColor = color.onSurfaceVariant;
        borderColor = Colors.transparent;
    }

    final hoveredBg = () {
      if (widget.variant == ButtonVariant.primary) {
        return color.primary.withOpacity(0.9);
      } else if (widget.variant == ButtonVariant.outline) {
        return color.primary.withOpacity(0.08);
      } else {
        return color.surfaceVariant.withOpacity(0.15);
      }
    }();

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.fullWidth ? double.infinity : null,
        height: height,
        decoration: BoxDecoration(
          color: _hovering ? hoveredBg : baseBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: color.shadow.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: widget.onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: widget.fullWidth
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              mainAxisSize:
                  widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon,
                      size: 18, color: textColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: textTheme.labelLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}