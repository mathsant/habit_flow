import 'package:flutter/material.dart';

class CategoryIconHelper {
  static const Map<String, IconData> _icons = {
    'favorite': Icons.favorite_outline,
    'fitness_center': Icons.fitness_center,
    'menu_book': Icons.menu_book,
    'self_improvement': Icons.self_improvement,
    'savings': Icons.savings_outlined,
    'people': Icons.people_outline,
    'palette': Icons.palette_outlined,
    'star': Icons.star_outline,
    'home': Icons.home_outlined,
    'work': Icons.work_outline,
    'restaurant': Icons.restaurant_outlined,
    'music_note': Icons.music_note,
    'directions_run': Icons.directions_run,
    'water_drop': Icons.water_drop_outlined,
    'bedtime': Icons.bedtime_outlined,
  };

  static IconData getIcon(String iconName) {
    return _icons[iconName] ?? Icons.category_outlined;
  }

  static List<String> get availableIcons => _icons.keys.toList();
}
