part of 'habit_bloc.dart';

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object> get props => [];
}

class LoadHabitsEvent extends HabitEvent {}

class CreateHabitEvent extends HabitEvent {
  final Habit habit;

  const CreateHabitEvent(this.habit);

  @override
  List<Object> get props => [habit];
}

class UpdateHabitEvent extends HabitEvent {
  final Habit habit;

  const UpdateHabitEvent(this.habit);

  @override
  List<Object> get props => [habit];
}

class DeleteHabitEvent extends HabitEvent {
  final String habitId;

  const DeleteHabitEvent(this.habitId);

  @override
  List<Object> get props => [habitId];
}

class ToggleCompletionEvent extends HabitEvent {
  final String habitId;

  const ToggleCompletionEvent(this.habitId);

  @override
  List<Object> get props => [habitId];
}
