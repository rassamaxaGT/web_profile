import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';
import 'neomorphic_card.dart';

class AbsurdPumpSlider extends StatefulWidget {
  const AbsurdPumpSlider({super.key});

  @override
  State<AbsurdPumpSlider> createState() => _AbsurdPumpSliderState();
}

class _AbsurdPumpSliderState extends State<AbsurdPumpSlider> {
  double _pressure = 24.0;
  bool _isPumping = false;
  Timer? _leakTimer;

  @override
  void initState() {
    super.initState();
    _startLeakTimer();
  }

  void _startLeakTimer() {
    _leakTimer?.cancel();
    _leakTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isPumping && _pressure > 0) {
        setState(() {
          _pressure = (_pressure - 1.2).clamp(0.0, 100.0);
        });
      }
    });
  }

  void _pump() {
    setState(() {
      _isPumping = true;
      _pressure = (_pressure + 14.0).clamp(0.0, 100.0);
    });

    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) setState(() => _isPumping = false);
    });
  }

  @override
  void dispose() {
    _leakTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeomorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Тактильный отклик интерфейса (Haptics)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: NeoColors.textPrimary,
                ),
              ),
              Text(
                '${_pressure.toInt()}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                  color: NeoColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: NeoSpacing.xs),
          const Text(
            'Калибровка давления вибромотора. Требуется ручная подкачка давления.',
            style: TextStyle(fontSize: 12, color: NeoColors.textSecondary),
          ),
          const SizedBox(height: NeoSpacing.md),

          // Шкала
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: NeoColors.surface,
              borderRadius: BorderRadius.circular(NeoRadius.full),
              boxShadow: [
                BoxShadow(
                  color: NeoColors.shadowDark.withValues(alpha: 0.35),
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-1, -1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: FractionallySizedBox(
              widthFactor: (_pressure / 100).clamp(0.0, 1.0),
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  color: NeoColors.sageDark,
                  borderRadius: BorderRadius.circular(NeoRadius.full),
                ),
              ),
            ),
          ),
          const SizedBox(height: NeoSpacing.md),

          // Замаскированная кнопка-поршень
          Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _pump,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  transform: _isPumping
                      ? Matrix4.translationValues(0.0, 4.0, 0.0)
                      : Matrix4.identity(),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  decoration: BoxDecoration(
                    color: _isPumping ? const Color(0xFFE2E3E8) : NeoColors.surface,
                    borderRadius: BorderRadius.circular(NeoRadius.full),
                    boxShadow: _isPumping
                        ? [
                            const BoxShadow(color: Color(0xFFC7CBD6), offset: Offset(2, 2), blurRadius: 3),
                            const BoxShadow(color: Colors.white, offset: Offset(-2, -2), blurRadius: 3),
                          ]
                        : NeoShadows.raisedSm(),
                  ),
                  child: Text(
                    _isPumping ? 'Нагнетание давления...' : 'Калибровать отклик',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: NeoColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
