import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';
import '../widgets/neomorphic_button.dart';

class HeaderSection extends StatelessWidget {
  final Function(String section) onNavClick;
  final VoidCallback onRotatePage;
  final VoidCallback onFlashlightToggle;
  final Offset cursorPos;

  const HeaderSection({
    super.key,
    required this.onNavClick,
    required this.onRotatePage,
    required this.onFlashlightToggle,
    this.cursorPos = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48.0 : 16.0,
        vertical: 20.0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: BorderRadius.circular(NeoRadius.full),
        border: null,
        boxShadow: NeoShadows.raisedMd(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo с пассивными глазами-радарами + Кнопка поворота страницы
          Row(
            children: [
              _EyeTrackingLogo(
                cursorPos: cursorPos,
                onTap: () => onNavClick('hero'),
              ),
              const SizedBox(width: 8),

              // Кнопка поворота страницы на 90° (Замаскирована под обычный рефреш)
              Tooltip(
                message: 'Обновить сессию',
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onRotatePage,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: NeoColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: NeoShadows.raisedSm(),
                      ),
                      child: const Icon(
                        Icons.refresh_rounded,
                        size: 16,
                        color: NeoColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: NeoSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Alexandr R.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: NeoColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Frontend & Flutter',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: NeoColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Nav links (Чистая, естественная навигация)
          if (isDesktop) ...[
            Row(
              children: [
                _NavLink(title: 'Обзор', onTap: () => onNavClick('hero')),
                _NavLink(title: 'Стек', onTap: () => onNavClick('skills')),
                _NavLink(title: 'Проекты', onTap: () => onNavClick('projects')),
                _NavLink(title: 'Параметры', onTap: () => onNavClick('lab')),
                _NavLink(title: 'Контакты', onTap: () => onNavClick('contact')),
              ],
            ),
          ],

          // Правый блок: кнопка темной темы и замаскированная убегающая кнопка «Связаться»
          Row(
            children: [
              Tooltip(
                message: 'Тёмная тема',
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onFlashlightToggle,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: NeoColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: NeoShadows.raisedSm(),
                      ),
                      child: const Icon(
                        Icons.dark_mode_outlined,
                        size: 16,
                        color: NeoColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Убегающая кнопка «Связаться»
              _FleeingButton(
                onPressed: () => onNavClick('contact'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FleeingButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _FleeingButton({required this.onPressed});

  @override
  State<_FleeingButton> createState() => _FleeingButtonState();
}

class _FleeingButtonState extends State<_FleeingButton> {
  double _offsetX = 0.0;
  int _fleeCount = 0;

  void _flee() {
    setState(() {
      _fleeCount++;
      if (_fleeCount % 2 == 1) {
        _offsetX = (Random().nextBool() ? 40.0 : -40.0);
      } else {
        _offsetX = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _flee(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutBack,
        transform: Matrix4.translationValues(_offsetX, 0.0, 0.0),
        child: NeomorphicButton(
          text: _fleeCount > 3 ? 'Поймал!' : 'Связаться',
          height: 40,
          accentColor: NeoColors.sage,
          textColor: NeoColors.sageDark,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavLink({required this.title, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _isHovered ? NeoColors.shadowDark.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(NeoRadius.full),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
              color: _isHovered ? NeoColors.textPrimary : NeoColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Логотип с пассивными глазами-радарами, которые следят за курсором мыши
class _EyeTrackingLogo extends StatelessWidget {
  final Offset cursorPos;
  final VoidCallback onTap;

  const _EyeTrackingLogo({
    required this.cursorPos,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Приблизительный центр логотипа в шапке
    const logoX = 90.0;
    const logoY = 40.0;

    final dx = cursorPos.dx - logoX;
    final dy = cursorPos.dy - logoY;
    final dist = sqrt(dx * dx + dy * dy);

    // Максимальное смещение зрачка внутри глазницы
    final maxPupilDist = 3.2;
    final pupilX = dist > 0 ? (dx / dist) * min(dist * 0.05, maxPupilDist) : 0.0;
    final pupilY = dist > 0 ? (dy / dist) * min(dist * 0.05, maxPupilDist) : 0.0;

    return Tooltip(
      message: 'Пассивная система визуального слежения за курсором',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: NeoColors.surface,
              shape: BoxShape.circle,
              boxShadow: NeoShadows.raisedSm(),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Глазки
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildEye(pupilX, pupilY),
                    const SizedBox(width: 4),
                    _buildEye(pupilX, pupilY),
                  ],
                ),
                // Микро-подпись AR снизу
                Positioned(
                  bottom: 4,
                  child: Text(
                    'AR',
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      color: NeoColors.textTertiary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEye(double px, double py) {
    return Container(
      width: 10,
      height: 13,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: NeoColors.shadowDark.withValues(alpha: 0.25),
            offset: const Offset(0.5, 0.5),
            blurRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Transform.translate(
          offset: Offset(px, py),
          child: Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: NeoColors.textPrimary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

