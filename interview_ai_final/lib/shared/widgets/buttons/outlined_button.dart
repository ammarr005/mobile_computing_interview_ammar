import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final Color? borderColor;
  final Color? foregroundColor;
  final Color? disabledForegroundColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? width;
  final double? height;

  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.borderColor,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.borderWidth = 1.0,
    this.borderRadius = 12.0,
    this.padding,
    this.textStyle,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Resolve border color & width
    final borderProperty = WidgetStateProperty.resolveWith<BorderSide?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return BorderSide(
          color: theme.colorScheme.onSurface.withOpacity(0.12),
          width: borderWidth,
        );
      }
      if (states.contains(WidgetState.pressed)) {
        return BorderSide(
          color: (borderColor ?? theme.colorScheme.primary).withOpacity(0.8),
          width: borderWidth,
        );
      }
      return BorderSide(
        color: borderColor ?? theme.colorScheme.outline,
        width: borderWidth,
      );
    });

    // Resolve foreground / text color
    final fgProperty = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return disabledForegroundColor ?? 
            theme.colorScheme.onSurface.withOpacity(0.38);
      }
      return foregroundColor ?? theme.colorScheme.primary;
    });

    final buttonStyle = OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: textStyle ?? theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    ).copyWith(
      side: borderProperty,
      foregroundColor: fgProperty,
    );

    Widget buttonPayload = icon != null
        ? OutlinedButton.icon(
            key: const Key('outlined_button_with_icon'),
            onPressed: onPressed,
            style: buttonStyle,
            icon: icon!,
            label: child,
          )
        : OutlinedButton(
            key: const Key('outlined_button_standard'),
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
