import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final Color? foregroundColor;
  final Color? disabledForegroundColor;
  final Color? pressedBackgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? width;
  final double? height;

  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.pressedBackgroundColor,
    this.borderRadius = 8.0,
    this.padding,
    this.textStyle,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Resolve foreground/text color based on states
    final fgProperty = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return disabledForegroundColor ?? 
            theme.colorScheme.onSurface.withOpacity(0.38);
      }
      return foregroundColor ?? theme.colorScheme.primary;
    });

    // Resolve overlay/background color on press
    final bgOverlayProperty = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        return pressedBackgroundColor ?? 
            (foregroundColor ?? theme.colorScheme.primary).withOpacity(0.12);
      }
      if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
        return (foregroundColor ?? theme.colorScheme.primary).withOpacity(0.08);
      }
      return Colors.transparent;
    });

    final buttonStyle = TextButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      textStyle: textStyle ?? theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    ).copyWith(
      foregroundColor: fgProperty,
      backgroundColor: bgOverlayProperty,
    );

    Widget buttonPayload = icon != null
        ? TextButton.icon(
            key: const Key('text_button_with_icon'),
            onPressed: onPressed,
            style: buttonStyle,
            icon: icon!,
            label: child,
          )
        : TextButton(
            key: const Key('text_button_standard'),
            onPressed: onPressed,
            style: buttonStyle,
            child: child,
          );

    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: buttonPayload,
      );
    }
    return buttonPayload;
  }
}
