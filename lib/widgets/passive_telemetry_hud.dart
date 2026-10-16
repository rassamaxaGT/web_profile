import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';

/// Плавающий телеметрический бейдж в углу экрана,
/// который в реальном времени пассивно реагирует на движения пользователя:
/// - Скорость движения мыши (с предупреждением о превышении скорости!)
/// - Режим бездействия (Zzz sleep mode при отсутствии движения 9 секунд)
class PassiveTelemetryHud extends StatefulWidget {
  final Offset cursorPos;
  final bool isSleeping;
  final double mouseSpeed;
  final bool isOverspeed;

  const PassiveTelemetryHud({
    super.key,
    required this.cursorPos,
    required this.isSleeping,
    required this.mouseSpeed,
    required this.isOverspeed,
  });

  @override
  State<PassiveTelemetryHud> createState() => _PassiveTelemetryHudState();
}

class _PassiveTelemetryHudState extends State<PassiveTelemetryHud>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(covariant PassiveTelemetryHud oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOverspeed && !oldWidget.isOverspeed) {
      _shakeController.repeat(reverse: true);
    } else if (!widget.isOverspeed && oldWidget.isOverspeed) {
      _shakeController.stop();
      _shakeController.reset();
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final speed = widget.mouseSpeed.clamp(0.0, 9999.0);
    final isAlert = widget.isOverspeed;
    final isSleep = widget.isSleeping;

    Color badgeColor = NeoColors.surface;
    Color textColor = NeoColors.textSecondary;
    IconData icon = Icons.speed_rounded;
    String statusText = 'Телеметрия: ${speed.toInt()} px/s';

    if (isSleep) {
      textColor = NeoColors.lavenderDark;
      icon = Icons.bedtime_rounded;
      statusText = 'Спящий режим (нет движений 9с)... zZz';
    } else if (isAlert) {
      textColor = NeoColors.roseDark;
      icon = Icons.warning_amber_rounded;
      statusText = 'ПРЕВЫШЕНИЕ: ${speed.toInt()} px/s! Сдувает тени!';
    }

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final shakeOffset = isAlert ? sin(_shakeController.value * pi * 4) * 4.0 : 0.0;

        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: child,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(NeoRadius.full),
          boxShadow: isAlert
              ? [
                  BoxShadow(
                    color: NeoColors.roseDark.withValues(alpha: 0.35),
                    offset: const Offset(2, 3),
                    blurRadius: 8,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-2, -3),
                    blurRadius: 6,
                  ),
                ]
              : NeoShadows.raisedSm(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedRotation(
              turns: isAlert ? 0.1 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: 15,
                color: textColor,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                fontWeight: isAlert ? FontWeight.w800 : FontWeight.w600,
                color: textColor,
              ),
              child: Text(statusText),
            ),
          ],
        ),
      ),
    );
  }
}
