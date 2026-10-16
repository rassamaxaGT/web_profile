import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';

/// Абсурдный строительный уровень страницы:
/// Пузырек пассивно перекатывается от положения курсора,
/// а клик по уровню "калибрует" горизонт, слегка наклоняя страницу.
class AbsurdBubbleLevel extends StatefulWidget {
  final Offset cursorPos;
  final Function(double tiltTurns) onTiltChanged;

  const AbsurdBubbleLevel({
    super.key,
    required this.cursorPos,
    required this.onTiltChanged,
  });

  @override
  State<AbsurdBubbleLevel> createState() => _AbsurdBubbleLevelState();
}

class _AbsurdBubbleLevelState extends State<AbsurdBubbleLevel> {
  int _tiltStep = 0;
  final List<double> _tiltAngles = [0.0, 0.008, -0.012, 0.0];

  void _cycleTilt() {
    setState(() {
      _tiltStep = (_tiltStep + 1) % _tiltAngles.length;
    });
    widget.onTiltChanged(_tiltAngles[_tiltStep]);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Пассивное смещение пузырька от положения мыши (-22px .. +22px)
    final normalizedX = screenWidth > 0 ? (widget.cursorPos.dx / screenWidth) - 0.5 : 0.0;
    final bubbleOffset = (normalizedX * 44.0).clamp(-22.0, 22.0);

    final currentTilt = _tiltAngles[_tiltStep];
    final isLevel = currentTilt == 0.0;

    return Tooltip(
      message: isLevel
          ? 'Строительный уровень страницы (Нажмите для калибровки горизонта)'
          : 'Горизонт нарушен (${(currentTilt * 360).toStringAsFixed(1)}°)! Нажмите для сброса',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _cycleTilt,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: NeoColors.surface,
              borderRadius: BorderRadius.circular(NeoRadius.full),
              boxShadow: NeoShadows.raisedSm(),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.straighten_rounded,
                  size: 14,
                  color: NeoColors.textTertiary,
                ),
                const SizedBox(width: 6),
                // Колба строительного уровня
                Container(
                  width: 64,
                  height: 14,
                  decoration: BoxDecoration(
                    color: NeoColors.sage.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: [
                      BoxShadow(
                        color: NeoColors.shadowDark.withValues(alpha: 0.2),
                        offset: const Offset(1, 1),
                        blurRadius: 1.5,
                      ),
                      const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-1, -1),
                        blurRadius: 1.5,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Риски центра
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 1, height: 10, color: NeoColors.sageDark.withValues(alpha: 0.4)),
                          const SizedBox(width: 14),
                          Container(width: 1, height: 10, color: NeoColors.sageDark.withValues(alpha: 0.4)),
                        ],
                      ),
                      // Живой пузырек воздуха
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeOut,
                        left: 26 + bubbleOffset,
                        child: Container(
                          width: 12,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: NeoColors.sageDark.withValues(alpha: 0.3),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isLevel ? '0.0°' : '${(currentTilt * 360).toStringAsFixed(1)}°',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                    color: isLevel ? NeoColors.textSecondary : NeoColors.roseDark,
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
