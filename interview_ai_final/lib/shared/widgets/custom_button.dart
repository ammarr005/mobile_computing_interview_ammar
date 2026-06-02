import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';

enum ButtonType { primary, secondary, text }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final IconData? icon;
  final Widget? iconWidget;
  final bool fullWidth;
  final double height;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.iconWidget,
    this.fullWidth = true,
    this.height = 54.0,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
      lowerBound: 0.0,
      upperBound: 0.03, // animate down to 0.97 scale
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (widget.iconWidget != null) ...[
          widget.iconWidget!,
          const SizedBox(width: 8.0),
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: 20, color: _getContentColor()),
          const SizedBox(width: 8.0),
        ],
        Text(
          widget.text,
          style: AppTypography.buttonText.copyWith(
            color: _getContentColor(),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: widget.fullWidth ? double.infinity : null,
          height: widget.height,
          child: _buildButtonByStyle(buttonContent),
        ),
      ),
    );
  }

  Color _getContentColor() {
    switch (widget.type) {
      case ButtonType.secondary:
        return AppColors.primary;
      case ButtonType.text:
        return AppColors.primary;
      case ButtonType.primary:
        return AppColors.onPrimary;
    }
  }

  Widget _buildButtonByStyle(Widget content) {
    if (widget.type == ButtonType.primary) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 4.0,
          shadowColor: AppColors.primary.withOpacity(0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: widget.onPressed,
        child: content,
      );
    } else if (widget.type == ButtonType.secondary) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: widget.onPressed,
        child: content,
      );
    } else {
      return TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999.0),
          ),
        ),
        onPressed: widget.onPressed,
        child: content,
      );
    }
  }
}
