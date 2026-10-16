import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';

class NeomorphicBadge extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color pastelColor;
  final Color textColor;
  final bool isSunken;

  const NeomorphicBadge({
    super.key,
    required this.text,
    this.icon,
    this.pastelColor = NeoColors.sage,
    this.textColor = NeoColors.sageDark,
    this.isSunken = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: pastelColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(NeoRadius.full),
        border: null, // Без обводок
        boxShadow: isSunken
            ? [
                BoxShadow(
                  color: NeoColors.shadowDark.withValues(alpha: 0.3),
                  offset: const Offset(1, 1),
                  blurRadius: 3,
                ),
              ]
            : [
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-2, -2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: NeoColors.shadowDark.withValues(alpha: 0.35),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
