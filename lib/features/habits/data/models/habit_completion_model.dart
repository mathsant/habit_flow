import '../../domain/entities/habit_completion.dart';

class HabitCompletionModel extends HabitCompletion {
  const HabitCompletionModel({
    required super.id,
    required super.habitId,
    required super.completedAt,
  });

  factory HabitCompletionModel.fromMap(Map<String, dynamic> map) {
    return HabitCompletionModel(
      id: map['id'] as String,
      habitId: map['habit_id'] as String,
      completedAt: DateTime.parse(map['completed_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habit_id': habitId,
      'completed_at': completedAt.toIso8601String(),
    };
  }
}
