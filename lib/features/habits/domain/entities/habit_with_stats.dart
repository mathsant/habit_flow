import 'package:equatable/equatable.dart';
import 'habit.dart';
import 'habit_completion.dart';

class HabitWithStats extends Equatable {
  final Habit habit;
  final List<HabitCompletion> completions;
  final bool isCompletedToday;
  final int currentStreak;

  const HabitWithStats({
    required this.habit,
    required this.completions,
    required this.isCompletedToday,
    required this.currentStreak,
  });

  @override
  List<Object> get props => [
    habit,
    completions,
    isCompletedToday,
    currentStreak,
  ];
}
