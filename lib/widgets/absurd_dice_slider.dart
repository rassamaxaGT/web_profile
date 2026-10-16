import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';
import 'neomorphic_card.dart';

class AbsurdDiceSlider extends StatefulWidget {
  const AbsurdDiceSlider({super.key});

  @override
  State<AbsurdDiceSlider> createState() => _AbsurdDiceSliderState();
}

class _AbsurdDiceSliderState extends State<AbsurdDiceSlider> {
  int _die1 = 3;
  int _die2 = 4;
  int _entropy = 58;
  String _status = 'Случайное распределение весов';

  void _rollDice() {
    final rand = Random();
    final d1 = rand.nextInt(6) + 1;
    final d2 = rand.nextInt(6) + 1;
    final sum = d1 + d2;
    int vol = ((sum / 12) * 100).round();

    String msg = 'Сид энтропии обновлен: $vol%';
    if (d1 == 1 && d2 == 1) {
      vol = 0;
      msg = 'Коллизия хеша: энтропия сброшена в ноль (0%)';
    } else if (d1 == 6 && d2 == 6) {
      vol = 100;
      msg = 'Максимальный энтропийный баланс (100%)';
    }

    setState(() {
      _die1 = d1;
      _die2 = d2;
      _entropy = vol;
      _status = msg;
    });
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
                'Генератор энтропии токенов (PRNG)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: NeoColors.textPrimary,
                ),
              ),
              Text(
                '$_entropy%',
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                  color: NeoColors.lavenderDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: NeoSpacing.xs),
          Text(
            _status,
            style: const TextStyle(fontSize: 12, color: NeoColors.textSecondary),
          ),
          const SizedBox(height: NeoSpacing.md),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DieWidget(value: _die1),
              const SizedBox(width: 14),
              _DieWidget(value: _die2),
              const SizedBox(width: 20),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _rollDice,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: NeoColors.surface,
                      borderRadius: BorderRadius.circular(NeoRadius.full),
                      boxShadow: NeoShadows.raisedSm(),
                    ),
                    child: const Text(
                      'Пересчитать сид',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: NeoColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DieWidget extends StatelessWidget {
  final int value;

  const _DieWidget({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: NeoShadows.raisedSm(),
      ),
      child: Center(
        child: Text(
          '$value',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: NeoColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
