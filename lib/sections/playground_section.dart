import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';
import '../widgets/absurd_dice_slider.dart';
import '../widgets/absurd_pump_slider.dart';
import '../widgets/neomorphic_badge.dart';
import '../widgets/neomorphic_button.dart';
import '../widgets/neomorphic_card.dart';
import '../widgets/neomorphic_input.dart';
import '../widgets/neomorphic_switch.dart';

class PlaygroundSection extends StatefulWidget {
  const PlaygroundSection({super.key});

  @override
  State<PlaygroundSection> createState() => _PlaygroundSectionState();
}

class _PlaygroundSectionState extends State<PlaygroundSection> {
  bool _stubbornSwitch = false;
  double _gridSpacing = 8.0;
  final TextEditingController _mirrorController = TextEditingController();

  void _onStubbornSwitchChanged(bool val) {
    setState(() => _stubbornSwitch = val);
    if (val) {
      Future.delayed(const Duration(milliseconds: 380), () {
        if (mounted) {
          setState(() => _stubbornSwitch = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: NeoColors.surface,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              content: const Text(
                'Аппаратный рендеринг: «Режим отклонён видеочипом для экономии энергии.»',
                style: TextStyle(color: NeoColors.textPrimary, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }
      });
    }
  }

  void _onMirrorChanged(String text) {
    if (text.isEmpty) return;
    final reversed = text.split('').reversed.join('');
    if (reversed != text) {
      _mirrorController.value = TextEditingValue(
        text: reversed,
        selection: TextSelection.collapsed(offset: reversed.length),
      );
    }
  }

  @override
  void dispose() {
    _mirrorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64.0 : 20.0,
        vertical: 40.0,
      ),
      child: Column(
        children: [
          const NeomorphicBadge(
            text: 'Настройки системы',
            pastelColor: NeoColors.lavender,
            textColor: NeoColors.lavenderDark,
          ),
          const SizedBox(height: NeoSpacing.md),
          Text(
            'Панель параметров интерфейса',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 34 : 24,
              fontWeight: FontWeight.w800,
              color: NeoColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: NeoSpacing.xs),
          const Text(
            'Интерактивная проверка профилирования рендеринга, точности сетки и тактильного отклика',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: NeoColors.textSecondary,
            ),
          ),
          const SizedBox(height: NeoSpacing.xl),

          // Два регулятора (замаскированы под Haptics и PRNG Seed)
          LayoutBuilder(
            builder: (context, constraints) {
              final colWidth = isDesktop ? (constraints.maxWidth - 24) / 2 : constraints.maxWidth;
              return Wrap(
                spacing: 24,
                runSpacing: 20,
                children: [
                  SizedBox(width: colWidth, child: const AbsurdPumpSlider()),
                  SizedBox(width: colWidth, child: const AbsurdDiceSlider()),
                ],
              );
            },
          ),
          const SizedBox(height: NeoSpacing.xl),

          // Карточка с переключателем и шагом сетки
          NeomorphicCard(
            width: double.infinity,
            padding: EdgeInsets.all(isDesktop ? 32 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Параметры графического конвейера',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: NeoColors.textPrimary,
                  ),
                ),
                const SizedBox(height: NeoSpacing.md),
                Wrap(
                  spacing: 36,
                  runSpacing: 20,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NeomorphicSwitch(
                          value: _stubbornSwitch,
                          activeColor: NeoColors.sage,
                          onChanged: _onStubbornSwitchChanged,
                        ),
                        const SizedBox(width: NeoSpacing.sm),
                        Text(
                          _stubbornSwitch ? 'Аппаратное ускорение (On)' : 'Аппаратное ускорение (Off)',
                          style: const TextStyle(fontSize: 13, color: NeoColors.textSecondary),
                        ),
                      ],
                    ),

                    // Шаг сетки (добавляет Пи или сбрасывает в ноль)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NeomorphicButton(
                          text: 'Сброс',
                          width: 58,
                          height: 38,
                          isPill: false,
                          borderRadius: NeoRadius.md,
                          onPressed: () => setState(() => _gridSpacing = 0.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '${_gridSpacing.toStringAsFixed(2)} dp',
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w700,
                              color: NeoColors.textPrimary,
                            ),
                          ),
                        ),
                        NeomorphicButton(
                          text: '+ Шаг',
                          width: 58,
                          height: 38,
                          isPill: false,
                          borderRadius: NeoRadius.md,
                          accentColor: NeoColors.lavender,
                          textColor: NeoColors.lavenderDark,
                          onPressed: () => setState(() => _gridSpacing += 3.14159),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: NeoSpacing.xl),

                // Тест кернинга (зеркальный ввод)
                NeomorphicInput(
                  controller: _mirrorController,
                  labelText: 'Тестирование кернинга и глифов шрифта',
                  hintText: 'Введите тестовую строку для проверки начертания...',
                  onChanged: _onMirrorChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
