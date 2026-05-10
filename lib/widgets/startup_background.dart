import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/app_styles.dart';

class StartupBackground extends StatelessWidget {
  final Widget child;

  const StartupBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Background
        Container(color: AppColors.background),
        
        // Soft Blur Shapes
        Positioned(
          top: -100,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withValues(alpha: 0.15),
            ),
          ),
        ),
        Positioned(
          top: 150,
          right: -100,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withValues(alpha: 0.12),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: 50,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.tertiary.withValues(alpha: 0.08),
            ),
          ),
        ),

        // Blur Filter over the shapes to make them look like mesh gradient
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
        ),

        // Foreground Content
        SafeArea(
          bottom: false,
          child: child,
        ),
      ],
    );
  }
}
