import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';

class NeomorphicButton extends StatefulWidget {
  final Widget? child;
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? accentColor;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool isPill;
  final double? width;
  final double? height;

  const NeomorphicButton({
    super.key,
    this.child,
    this.text,
    this.icon,
    this.onPressed,
    this.accentColor,
    this.textColor,
    this.borderRadius = NeoRadius.md,
    this.padding,
    this.isLoading = false,
    this.isPill = true,
    this.width,
    this.height = 46.0,
  });

  @override
  State<NeomorphicButton> createState() => _NeomorphicButtonState();
}

class _NeomorphicButtonState extends State<NeomorphicButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;
    final double radius = widget.isPill ? NeoRadius.full : widget.borderRadius;

    // Расчет цвета фона
    Color bg = NeoColors.surface;
    if (_isPressed) {
      bg = const Color(0xFFE2E3E8); // Слегка вдавленный тон
    } else if (widget.accentColor != null) {
      bg = Color.lerp(NeoColors.surface, widget.accentColor, 0.25)!;
    }

    // Расчет теней
    List<BoxShadow> shadows = [];
    if (!isEnabled) {
      shadows = [];
    } else if (_isPressed) {
      // Тактильное вдавливание
      shadows = [
        const BoxShadow(
          color: Color(0xFFC7CBD6),
          offset: Offset(2, 2),
          blurRadius: 4,
        ),
        const BoxShadow(
          color: Color(0xFFFFFFFF),
          offset: Offset(-2, -2),
          blurRadius: 4,
        ),
      ];
    } else if (_isHovered) {
      shadows = NeoShadows.raisedMd();
    } else {
      shadows = NeoShadows.raisedSm();
    }

    final Color textAndIconColor = widget.textColor ?? NeoColors.textPrimary;

    Widget content;
    if (widget.isLoading) {
      content = SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(textAndIconColor),
        ),
      );
    } else if (widget.child != null) {
      content = widget.child!;
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 16, color: textAndIconColor),
            const SizedBox(width: NeoSpacing.sm),
          ],
          if (widget.text != null)
            Flexible(
              child: Text(
                widget.text!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textAndIconColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
        ],
      );
    }

    // Безопасный расчет отступов: если задана фиксированная высота, центрируем без жесткого вертикального паддинга
    final effectivePadding = widget.padding ??
        (widget.height != null
            ? const EdgeInsets.symmetric(horizontal: 18)
            : const EdgeInsets.symmetric(horizontal: 22, vertical: 12));

    return MouseRegion(
      onEnter: isEnabled ? (_) => setState(() => _isHovered = true) : null,
      onExit: isEnabled ? (_) => setState(() => _isHovered = false) : null,
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
        onTap: isEnabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutQuad,
          width: widget.width,
          height: widget.height,
          padding: effectivePadding,
          transform: _isHovered && !_isPressed
              ? Matrix4.translationValues(0.0, -1.5, 0.0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(radius),
            border: null, // Никаких обводок
            boxShadow: shadows,
          ),
          child: Center(child: content),
        ),
      ),
    );
  }
}
