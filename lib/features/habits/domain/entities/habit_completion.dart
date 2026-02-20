import 'package:equatable/equatable.dart';

class HabitCompletion extends Equatable {
  final String id;
  final String habitId;
  final DateTime completedAt;

  const HabitCompletion({
    required this.id,
    required this.habitId,
    required this.completedAt,
  });

  DateTime get dateOnly =>
      DateTime(completedAt.year, completedAt.month, completedAt.day);

  @override
  List<Object?> get props => [id, habitId, completedAt];
}
