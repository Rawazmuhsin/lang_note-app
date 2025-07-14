import 'package:flutter/material.dart';

class ThemeColors {
  // Primary gradient colors
  static const Color primaryPurple = Color(0xFF667EEA);
  static const Color primaryBlue = Color(0xFF764BA2);

  // Background colors
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardBackground = Colors.white;

  // Category colors
  static const Map<String, Color> categoryColors = {
    'greeting': Color(0xFF10B981),
    'food & drink': Color(0xFFF59E0B),
    'travel': Color(0xFF3B82F6),
    'courtesy': Color(0xFF8B5CF6),
    'relationships': Color(0xFFEF4444),
    'business': Color(0xFF6B7280),
    'academic': Color(0xFF06B6D4),
    'general': Color(0xFF64748B),
  };

  // Semantic colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningRed = Color(0xFFEF4444);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF374151);
  static const Color textMuted = Color(0xFF6B7280);

  // Helper method to get category color
  static Color getCategoryColor(String category) {
    return categoryColors[category.toLowerCase()] ?? categoryColors['general']!;
  }
}

class AppGradients {
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.primaryPurple, ThemeColors.primaryBlue],
  );

  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ThemeColors.successGreen, Color(0xFF059669)],
  );

  static LinearGradient categoryGradient(String category) {
    final color = ThemeColors.getCategoryColor(category);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color, color.withOpacity(0.8)],
    );
  }
}
