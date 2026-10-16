import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';
import '../widgets/neomorphic_button.dart';
import '../widgets/neomorphic_card.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onProjectsClick;
  final VoidCallback onContactClick;
  final bool isScrolled;

  const HeroSection({
    super.key,
    required this.onProjectsClick,
    required this.onContactClick,
    this.isScrolled = false,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  int _statusStep = 0;
  final List<Map<String, dynamic>> _statuses = [
    {'text': 'Доступен для контрактной разработки', 'color': NeoColors.sageDark},
    {'text': 'Занят, пожалуйста, не пишите', 'color': NeoColors.peachDark},
    {'text': 'Спит (не будить до 14:00)', 'color': NeoColors.lavenderDark},
    {'text': 'Случайно нажал rm -rf / на сервере', 'color': NeoColors.roseDark},
    {'text': 'Статус сбежал от разработчика...', 'color': NeoColors.textTertiary},
  ];

  void _cycleStatus() {
    setState(() {
      _statusStep = (_statusStep + 1) % _statuses.length;
    });
  }

  void _downloadJokeResume(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: NeoColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 6,
        content: const Text(
          '📄 Скачан файл «resume.txt» (1 байт):\n«Я умею центрировать <div> и писать BLoC»',
          style: TextStyle(color: NeoColors.textPrimary, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final currentStatus = _statuses[_statusStep];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64.0 : 20.0,
        vertical: 36.0,
      ),
      child: Column(
        children: [
          // Интерактивный статус с пассивным уклонением от курсора (магнитное отталкивание)
          _MagneticStatusBadge(
            currentStatus: currentStatus,
            onTap: _cycleStatus,
          ),
          const SizedBox(height: NeoSpacing.lg),
          const SizedBox(height: NeoSpacing.lg),

          // Заголовок
          Text(
            'Инженерный подход к фронтенду\nи дизайн-системам',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 48 : 30,
              fontWeight: FontWeight.w800,
              height: 1.15,
              color: NeoColors.textPrimary,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: NeoSpacing.md),

          // Описание
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: const Text(
              'Специализируюсь на Flutter, Dart и веб-платформах. Создаю масштабируемые интерфейсы, выстраиваю компонентные библиотеки на базе строгих токенов и оптимизирую производительность рендеринга.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: NeoColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: NeoSpacing.xl),

          // Кнопки действий
          Wrap(
            spacing: NeoSpacing.md,
            runSpacing: NeoSpacing.md,
            alignment: WrapAlignment.center,
            children: [
              NeomorphicButton(
                text: 'Смотреть проекты',
                accentColor: NeoColors.lavender,
                textColor: NeoColors.lavenderDark,
                onPressed: widget.onProjectsClick,
              ),
              NeomorphicButton(
                text: 'Связаться',
                accentColor: NeoColors.sage,
                textColor: NeoColors.sageDark,
                onPressed: widget.onContactClick,
              ),
              NeomorphicButton(
                text: 'Резюме (PDF)',
                textColor: NeoColors.textSecondary,
                onPressed: () => _downloadJokeResume(context),
              ),
            ],
          ),
          const SizedBox(height: NeoSpacing.xxl),

          // 3 плашки, которые физически падают просто при пролистывании страницы!
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = isDesktop ? (constraints.maxWidth - 48) / 3 : constraints.maxWidth;

              return Column(
                children: [
                  Wrap(
                    spacing: 24,
                    runSpacing: 20,
                    children: [
                      _FallingFocusCard(
                        width: cardWidth,
                        cardIndex: 0,
                        isFallen: widget.isScrolled,
                        tag: 'ПЛАТФОРМА',
                        title: 'Flutter Web & Desktop',
                        subtitle: 'Единая база кода для веб и мобильных клиентов с нативным профилированием и высоким FPS.',
                        accentColor: NeoColors.lavenderDark,
                      ),
                      _FallingFocusCard(
                        width: cardWidth,
                        cardIndex: 1,
                        isFallen: widget.isScrolled,
                        tag: 'АРХИТЕКТУРА',
                        title: 'Clean Architecture & BLoC',
                        subtitle: 'Изоляция слоёв данных, доменная логика без сайд-эффектов и детерминированное управление состоянием.',
                        accentColor: NeoColors.sageDark,
                      ),
                      _FallingFocusCard(
                        width: cardWidth,
                        cardIndex: 2,
                        isFallen: widget.isScrolled,
                        tag: 'ДИЗАЙН-КОД',
                        title: 'Токены & Компоненты',
                        subtitle: 'Строгая система стилей: никаких случайных отступов, согласованные отклики состояний и доступность.',
                        accentColor: NeoColors.peachDark,
                      ),
                    ],
                  ),
                  if (widget.isScrolled) ...[
                    const SizedBox(height: 16),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: widget.isScrolled ? 1.0 : 0.0,
                      child: const Text(
                        'Осторожно: незакреплённые плашки сорвались от инерции скролла (прокрутите наверх для калибровки)',
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: NeoColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FallingFocusCard extends StatefulWidget {
  final double width;
  final int cardIndex;
  final bool isFallen;
  final String tag;
  final String title;
  final String subtitle;
  final Color accentColor;

  const _FallingFocusCard({
    required this.width,
    required this.cardIndex,
    required this.isFallen,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });

  @override
  State<_FallingFocusCard> createState() => _FallingFocusCardState();
}

class _FallingFocusCardState extends State<_FallingFocusCard> {
  double _manualTilt = 0.0;

  @override
  Widget build(BuildContext context) {
    // Реалистичная физика срыва с креплений при скролле страницы:
    // 0-я плашка: сорвалась левая петля, наклон -8° (-0.14 рад), просадка 32px
    // 1-я плашка: повисла на одном шурупе, наклон +13° (+0.22 рад), просадка 65px
    // 2-я плашка: полностью сорвалась со стены, наклон -28° (-0.48 рад), падение 105px на пол!
    double rotation = _manualTilt;
    double dy = 0.0;

    if (widget.isFallen) {
      switch (widget.cardIndex) {
        case 0:
          rotation += -0.14;
          dy = 32.0;
          break;
        case 1:
          rotation += 0.22;
          dy = 65.0;
          break;
        case 2:
          rotation += -0.48;
          dy = 105.0;
          break;
      }
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _manualTilt += (Random().nextBool() ? 0.09 : -0.09);
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500 + (widget.cardIndex * 160)),
        curve: Curves.easeOutBack,
        transform: Matrix4.translationValues(0.0, dy, 0.0)..rotateZ(rotation),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            NeomorphicCard(
              width: widget.width,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.tag,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: widget.accentColor,
                        ),
                      ),
                      if (widget.isFallen)
                        Text(
                          widget.cardIndex == 2 ? '💥 УПАЛА' : '⚠️ СОСКОЧИЛА',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: widget.cardIndex == 2 ? NeoColors.roseDark : NeoColors.peachDark,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: NeoSpacing.sm),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: NeoColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: NeoSpacing.xs),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: NeoColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Торчащий вылетевший шуруп/гвоздь в углу при падении
            if (widget.isFallen)
              Positioned(
                top: -8,
                right: widget.cardIndex == 1 ? 12 : null,
                left: widget.cardIndex != 1 ? 12 : null,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: NeoColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: NeoShadows.raisedSm(),
                  ),
                  child: const Icon(
                    Icons.build_circle_outlined,
                    size: 13,
                    color: NeoColors.textTertiary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Статус-бейдж, который пассивно уклоняется от курсора мыши (магнитное отталкивание)
class _MagneticStatusBadge extends StatefulWidget {
  final Map<String, dynamic> currentStatus;
  final VoidCallback onTap;

  const _MagneticStatusBadge({
    required this.currentStatus,
    required this.onTap,
  });

  @override
  State<_MagneticStatusBadge> createState() => _MagneticStatusBadgeState();
}

class _MagneticStatusBadgeState extends State<_MagneticStatusBadge> {
  double _dodgeX = 0.0;
  bool _toRight = true;

  void _dodge() {
    setState(() {
      _dodgeX = _toRight ? 45.0 : -45.0;
      _toRight = !_toRight;
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _dodgeX = 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _dodge(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutBack,
          transform: Matrix4.translationValues(_dodgeX, 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: NeoColors.surface,
            borderRadius: BorderRadius.circular(NeoRadius.full),
            boxShadow: NeoShadows.raisedSm(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: widget.currentStatus['color'] as Color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.currentStatus['text'] as String,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: widget.currentStatus['color'] as Color,
                ),
              ),
              if (_dodgeX != 0) ...[
                const SizedBox(width: 6),
                const Text(
                  '💨 уклонение',
                  style: TextStyle(fontSize: 10, color: NeoColors.textTertiary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

