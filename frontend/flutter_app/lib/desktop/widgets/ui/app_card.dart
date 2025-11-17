import 'package:flutter/material.dart';

class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? color;
  final double radius;
  final bool shadow;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.margin = EdgeInsets.zero,
    this.color,
    this.radius = 12,
    this.shadow = true,
    this.onTap,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: _hovering
              ? (widget.color ?? color.surface)
                  .withOpacity(widget.color != null ? 1 : 0.97)
              : (widget.color ?? color.surface),
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(color: color.outlineVariant),
          boxShadow: widget.shadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(_hovering ? 0.1 : 0.05),
                    blurRadius: _hovering ? 12 : 6,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: widget.onTap != null
            ? InkWell(
                borderRadius: BorderRadius.circular(widget.radius),
                onTap: widget.onTap,
                child: widget.child,
              )
            : widget.child,
      ),
    );
  }
}