import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Lavender/Purple
  static const Color primary = Color(0xFF7C6FCD);
  static const Color primaryLight = Color(0xFF9E94D8);
  static const Color primaryDark = Color(0xFF5A4FB0);

  // Background
  static const Color background = Color(0xFFF4F2FF);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundCard = Color(0xFFEEEBFF);

  // Accent colors (untuk subject)
  static const Color mathColor = Color(0xFFFF8FAB);      // pink-merah
  static const Color biologyColor = Color(0xFF72D5A3);   // hijau mint
  static const Color englishColor = Color(0xFF64B5F6);   // biru muda
  static const Color accentYellow = Color(0xFFFFD166);   // kuning cerah

  // Text
  static const Color textPrimary = Color(0xFF1A1446);
  static const Color textSecondary = Color(0xFF6B6B8D);
  static const Color textHint = Color(0xFFB0AEC8);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFB74D);

  // Card gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B7FD4), Color(0xFF6A5BC2)],
  );

  static const LinearGradient mathGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8FAB), Color(0xFFFF6B8A)],
  );

  static const LinearGradient biologyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF72D5A3), Color(0xFF43C47F)],
  );

  static const LinearGradient englishGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
  );

  static const LinearGradient levelCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9B8FE0), Color(0xFF7C6FCD)],
  );

  static const LinearGradient finalQuizGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB347), Color(0xFFFF7043)],
  );

  // Shadow
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF7C6FCD).withValues(alpha: 0.12),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
