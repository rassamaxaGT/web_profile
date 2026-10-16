import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        children: [
          // Лаконичные неоморфные кнопки соцсетей без дефолтных Material иконок
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _SocialTextButton(
                title: 'GitHub',
                onTap: () => _openSocial(context, 'github.com/developer'),
              ),
              _SocialTextButton(
                title: 'Telegram',
                onTap: () => _openSocial(context, '@alex_developer'),
              ),
              _SocialTextButton(
                title: 'LinkedIn',
                onTap: () => _openSocial(context, 'linkedin.com/in/developer'),
              ),
              _SocialTextButton(
                title: 'Email',
                onTap: () => _openSocial(context, 'alex@domain.com'),
              ),
            ],
          ),
          const SizedBox(height: NeoSpacing.lg),

          const Text(
            'Flutter Web • Дизайн-система Pastel Neomorphism • Без внешних обводок',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: NeoColors.textSecondary,
            ),
          ),
          const SizedBox(height: NeoSpacing.xs),

          const Text(
            '© 2026 Richard Brook',
            style: TextStyle(
              fontSize: 11,
              color: NeoColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  void _openSocial(BuildContext context, String info) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: NeoColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(
          info,
          style: const TextStyle(color: NeoColors.textPrimary, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class _SocialTextButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _SocialTextButton({
    required this.title,
    required this.onTap,
  });

  @override
  State<_SocialTextButton> createState() => _SocialTextButtonState();
}

class _SocialTextButtonState extends State<_SocialTextButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isPressed ? const Color(0xFFE2E3E8) : NeoColors.surface,
            borderRadius: BorderRadius.circular(NeoRadius.full),
            boxShadow: _isPressed
                ? [
                    const BoxShadow(color: Color(0xFFC7CBD6), offset: Offset(1.5, 1.5), blurRadius: 2),
                    const BoxShadow(color: Colors.white, offset: Offset(-1.5, -1.5), blurRadius: 2),
                  ]
                : (_isHovered ? NeoShadows.raisedMd() : NeoShadows.raisedSm()),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _isHovered ? NeoColors.lavenderDark : NeoColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
