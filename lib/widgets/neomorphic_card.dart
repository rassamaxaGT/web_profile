import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';

class NeomorphicCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool enableHover;
  final Color? backgroundColor;

  const NeomorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius = NeoRadius.lg,
    this.onTap,
    this.enableHover = true,
    this.backgroundColor,
  });

  @override
  State<NeomorphicCard> createState() => _NeomorphicCardState();
}

class _NeomorphicCardState extends State<NeomorphicCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? NeoColors.surface;

    return MouseRegion(
      onEnter: widget.enableHover ? (_) => setState(() => _isHovered = true) : null,
      onExit: widget.enableHover ? (_) => setState(() => _isHovered = false) : null,
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          padding: widget.padding ?? const EdgeInsets.all(NeoSpacing.lg),
          transform: _isHovered ? Matrix4.translationValues(0.0, -3.0, 0.0) : Matrix4.identity(),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: null, // Строго никаких обводок
            boxShadow: _isHovered
                ? NeoShadows.raisedLg()
                : NeoShadows.raisedMd(),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
