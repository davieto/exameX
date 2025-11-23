import 'package:flutter/material.dart';

class AppTabs extends StatefulWidget {
  final List<String> tabs;
  final int initialIndex;
  final ValueChanged<int>? onChanged;
  const AppTabs({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onChanged,
  });

  @override
  State<AppTabs> createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> {
  late int current;

  @override
  void initState() {
    super.initState();
    current = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Exibir apenas em desktop
        if (constraints.maxWidth < 1024) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(widget.tabs.length, (i) {
                final selected = i == current;
                return InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    setState(() => current = i);
                    widget.onChanged?.call(i);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color:
                          selected ? color.surfaceContainerHighest.withOpacity(0.4) : Colors.transparent,
                    ),
                    child: Text(
                      widget.tabs[i],
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected ? color.onSurface : color.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 2),
            // Linha inferior animada
            Stack(
              children: [
                Container(height: 2, color: color.outlineVariant),
                AnimatedAlign(
                  alignment: Alignment(
                    (current / (widget.tabs.length - 1)) * 2 - 1,
                    0,
                  ),
                  duration: const Duration(milliseconds: 200),
                  child: FractionallySizedBox(
                    widthFactor: 1 / widget.tabs.length,
                    child: Container(height: 2, color: color.primary),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}