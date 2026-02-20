import 'package:flutter/material.dart';

class AppColors {
  // Primária
  static const primary = Color(0xFF6C63FF);
  static const primaryLight = Color(0xFFEEEDFF);

  // Neutros
  static const background = Color(0xFFF8F8F8);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const divider = Color(0xFFE5E7EB);

  // Categorias (cores para os hábitos)
  static const categoryColors = [
    Color(0xFF6C63FF), // Roxo
    Color(0xFF10B981), // Verde
    Color(0xFFF59E0B), // Amarelo
    Color(0xFFEF4444), // Vermelho
    Color(0xFF3B82F6), // Azul
    Color(0xFFEC4899), // Rosa
    Color(0xFF8B5CF6), // Violeta
    Color(0xFF14B8A6), // Teal
  ];

  // Streak
  static const streakActive = Color(0xFFF59E0B);
  static const streakInactive = Color(0xFFE5E7EB);

  // Status
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
}
