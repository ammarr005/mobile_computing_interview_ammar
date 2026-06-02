import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final double? elevation;
  final double? pressedElevation;
  final double? hoveredElevation;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? width;
  final double? height;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.elevation,
    this.pressedElevation,
    this.hoveredElevation,
    this.borderRadius = 12.0,
    this.padding,
    this.textStyle,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Resolve background color based on interactive states
    final bgProperty = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return disabledBackgroundColor ?? 
            theme.colorScheme.onSurface.withOpacity(0.12);
      }
      if (states.contains(WidgetState.pressed)) {
        return (backgroundColor ?? theme.colorScheme.primary).withOpacity(0.85);
      }
      return backgroundColor ?? theme.colorScheme.primary;
    });

    // Resolve foreground/text color based on interactive states
    final fgProperty = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return disabledForegroundColor ?? 
            theme.colorScheme.onSurface.withOpacity(0.38);
      }
      return foregroundColor ?? theme.colorScheme.onPrimary;
    });

    // Resolve elevation based on states
    final elevationProperty = WidgetStateProperty.resolveWith<double>((states) {
      if (states.contains(WidgetState.disabled)) {
        return 0.0;
      }
      if (states.contains(WidgetState.pressed)) {
        return pressedElevation ?? elevation ?? 2.0;
      }
      if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
        return hoveredElevation ?? (elevation ?? 1.0) + 2.0;
      }
      return elevation ?? 1.0;
    });

    final buttonStyle = ElevatedButton.styleFrom(
      shadowColor: theme.colorScheme.shadow,
      surfaceTintColor: theme.colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: textStyle ?? theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    ).copyWith(
      backgroundColor: bgProperty,
      foregroundColor: fgProperty,
      elevation: elevationProperty,
    );

    Widget buttonPayload = icon != null 
        ? ElevatedButton.icon(
            key: const Key('elevated_button_with_icon'),
            onPressed: onPressed,
            style: buttonStyle,
            icon: icon!,
            label: child,
          )
        : ElevatedButton(
            key: const Key('elevated_button_standard'),
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
