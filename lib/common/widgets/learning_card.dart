import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';

class LearningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final String? iconAsset; // opsional: path asset PNG
  final LinearGradient gradient;
  final VoidCallback onTap;
  final Widget? trailing;

  const LearningCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.emoji,
    this.iconAsset,
    required this.gradient,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            // Icon: asset PNG jika ada, fallback ke emoji
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: iconAsset != null
                    ? Image.asset(
                        iconAsset!,
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      )
                    : Text(emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3White),
                  const SizedBox(height: 3),
                  Text(subtitle, style: AppTextStyles.bodyWhite),
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (trailing == null)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
