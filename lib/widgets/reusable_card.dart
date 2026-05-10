import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

class ReusableCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final VoidCallback? onTap;
  final BoxBorder? border;

  const ReusableCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        padding: padding ?? const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.md),
          boxShadow: theme.brightness == Brightness.light ? AppColors.softShadow : null,
          border: border ?? Border.all(color: theme.dividerColor.withOpacity(0.1)),
        ),
        child: child,
      ),
    );
  }
}
