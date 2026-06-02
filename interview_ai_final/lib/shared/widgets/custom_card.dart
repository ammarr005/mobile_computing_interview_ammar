import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final Color? borderLeftColor;
  final double padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const CustomCard({
    Key? key,
    required this.child,
    this.backgroundColor = AppColors.surfaceContainerLowest,
    this.borderLeftColor,
    this.padding = 16.0,
    this.borderRadius = 16.0,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: _isHovered 
              ? AppColors.primary.withOpacity(0.4) 
              : AppColors.outlineVariant.withOpacity(0.3),
          width: _isHovered ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: _isHovered 
                ? AppColors.primary.withOpacity(0.08) 
                : const Color(0x0A0F172A),
            blurRadius: _isHovered ? 20.0 : 15.0,
            spreadRadius: _isHovered ? 1.0 : 0.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (widget.borderLeftColor != null)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4.0,
              child: Container(color: widget.borderLeftColor),
            ),
          Padding(
            padding: EdgeInsets.only(
              left: widget.padding + (widget.borderLeftColor != null ? 4.0 : 0.0),
              top: widget.padding,
              right: widget.padding,
              bottom: widget.padding,
            ),
            child: widget.child,
          ),
        ],
      ),
    );

    if (widget.onTap != null) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) {
            _controller.reverse();
            widget.onTap!();
          },
          onTapCancel: () => _controller.reverse(),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: cardContent,
          ),
        ),
      );
    }
    
    return cardContent;
  }
}
