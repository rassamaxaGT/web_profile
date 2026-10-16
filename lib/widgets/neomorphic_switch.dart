import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';

class NeomorphicSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  const NeomorphicSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = NeoColors.sage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 54,
          height: 30,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value
                ? Color.lerp(NeoColors.surface, activeColor, 0.45)
                : NeoColors.surface,
            borderRadius: BorderRadius.circular(NeoRadius.full),
            border: null, // Без обводок
            boxShadow: [
              // Вдавленный трек
              BoxShadow(
                color: NeoColors.shadowDark.withValues(alpha: 0.5),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-2, -2),
                blurRadius: 4,
              ),
            ],
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: NeoColors.surface,
                shape: BoxShape.circle,
                border: null,
                boxShadow: [
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-2, -2),
                    blurRadius: 3,
                  ),
                  BoxShadow(
                    color: NeoColors.shadowDark.withValues(alpha: 0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
