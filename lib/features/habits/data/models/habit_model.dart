import '../../domain/entities/habit.dart';

class HabitModel extends Habit {
  const HabitModel({
    required super.id,
    required super.title,
    super.description,
    required super.categoryId,
    required super.colorIndex,
    required super.createdAt,
  });

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      categoryId: map['category_id'] as String,
      colorIndex: map['color_index'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category_id': categoryId,
      'color_index': colorIndex,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory HabitModel.fromEntity(Habit habit) {
    return HabitModel(
      id: habit.id,
      title: habit.title,
      description: habit.description,
      categoryId: habit.categoryId,
      colorIndex: habit.colorIndex,
      createdAt: habit.createdAt,
    );
  }
}
