import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';

class CustomProgressBar extends StatelessWidget {
  final double value; // 0.0 - 1.0
  final Color? activeColor;
  final Color? backgroundColor;
  final double height;
  final bool showLabel;
  final String? label;

  const CustomProgressBar({
    super.key,
    required this.value,
    this.activeColor,
    this.backgroundColor,
    this.height = 10,
    this.showLabel = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0);
    final percent = (clampedValue * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(label!, style: AppTextStyles.bodySmall),
                Text(
                  '$percent%',
                  style: AppTextStyles.label.copyWith(
                    color: activeColor ?? AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: LinearProgressIndicator(
            value: clampedValue,
            minHeight: height,
            backgroundColor:
                backgroundColor ?? AppColors.primary.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(
              activeColor ?? AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Progress bar khusus untuk card level (warna putih)
class WhiteProgressBar extends StatelessWidget {
  final double value;
  final double height;

  const WhiteProgressBar({
    super.key,
    required this.value,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: Colors.white.withValues(alpha: 0.3),
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}
