import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';

class NeomorphicInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final Color focusGlowColor;

  const NeomorphicInput({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onChanged,
    this.focusGlowColor = NeoColors.lavender,
  });

  @override
  State<NeomorphicInput> createState() => _NeomorphicInputState();
}

class _NeomorphicInputState extends State<NeomorphicInput> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: NeoSpacing.xs, bottom: NeoSpacing.xs),
            child: Text(
              widget.labelText!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: NeoColors.textSecondary,
              ),
            ),
          ),
        ],
        CustomPaint(
          painter: _SunkenPainter(
            radius: NeoRadius.md,
            shadowDark: NeoColors.shadowDark,
            shadowLight: NeoColors.shadowLight,
            hasFocus: _isFocused,
            focusGlow: widget.focusGlowColor,
          ),
          child: Container(
            constraints: BoxConstraints(
              minHeight: widget.maxLines > 1 ? 96.0 : 48.0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: widget.maxLines > 1
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                if (widget.prefixIcon != null) ...[
                  Padding(
                    padding: EdgeInsets.only(top: widget.maxLines > 1 ? 2 : 0),
                    child: Icon(
                      widget.prefixIcon,
                      size: 20,
                      color: _isFocused ? NeoColors.textPrimary : NeoColors.textTertiary,
                    ),
                  ),
                  const SizedBox(width: NeoSpacing.sm),
                ],
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    obscureText: widget.obscureText,
                    keyboardType: widget.keyboardType,
                    maxLines: widget.maxLines,
                    onChanged: widget.onChanged,
                    style: const TextStyle(
                      fontSize: 14,
                      color: NeoColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: widget.hintText,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: NeoColors.textTertiary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                if (widget.suffix != null) ...[
                  const SizedBox(width: NeoSpacing.sm),
                  widget.suffix!,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SunkenPainter extends CustomPainter {
  final double radius;
  final Color shadowDark;
  final Color shadowLight;
  final bool hasFocus;
  final Color focusGlow;

  _SunkenPainter({
    required this.radius,
    required this.shadowDark,
    required this.shadowLight,
    required this.hasFocus,
    required this.focusGlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    canvas.save();
    canvas.clipRRect(rrect);

    // Базовый цвет фона
    canvas.drawRRect(rrect, Paint()..color = NeoColors.surface);

    // Темная тень сверху-слева
    final darkPaint = Paint()
      ..color = shadowDark.withValues(alpha: 0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final darkPath = Path()
      ..moveTo(-4, size.height + 4)
      ..lineTo(-4, -4)
      ..lineTo(size.width + 4, -4);
    canvas.drawPath(darkPath, darkPaint);

    // Светлый блик снизу-справа
    final lightPaint = Paint()
      ..color = shadowLight.withValues(alpha: 0.95)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final lightPath = Path()
      ..moveTo(-4, size.height + 4)
      ..lineTo(size.width + 4, size.height + 4)
      ..lineTo(size.width + 4, -4);
    canvas.drawPath(lightPath, lightPaint);

    if (hasFocus) {
      final glowPaint = Paint()
        ..color = focusGlow.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawRRect(rrect, glowPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SunkenPainter oldDelegate) {
    return oldDelegate.hasFocus != hasFocus || oldDelegate.radius != radius;
  }
}
