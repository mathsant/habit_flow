import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_flow/core/usecase/usecase.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_with_stats.dart';
import '../../domain/usecases/create_habit.dart';
import '../../domain/usecases/delete_habit.dart';
import '../../domain/usecases/get_habits_with_stats.dart';
import '../../domain/usecases/toggle_completion.dart';
import '../../domain/usecases/update_habit.dart';

part 'habit_event.dart';
part 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final GetHabitsWithStats getHabitsWithStats;
  final CreateHabit createHabit;
  final UpdateHabit updateHabit;
  final DeleteHabit deleteHabit;
  final ToggleCompletion toggleCompletion;

  HabitBloc({
    required this.getHabitsWithStats,
    required this.createHabit,
    required this.updateHabit,
    required this.deleteHabit,
    required this.toggleCompletion,
  }) : super(HabitInitial()) {
    on<LoadHabitsEvent>(_onLoadHabits);
    on<CreateHabitEvent>(_onCreateHabit);
    on<UpdateHabitEvent>(_onUpdateHabit);
    on<DeleteHabitEvent>(_onDeleteHabit);
    on<ToggleCompletionEvent>(_onToggleCompletion);
  }

  Future<void> _onLoadHabits(
    LoadHabitsEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());

    final result = await getHabitsWithStats(NoParams());

    result.fold(
      (failure) => emit(HabitError(failure.message)),
      (habits) => emit(HabitLoaded(habits)),
    );
  }

  Future<void> _onCreateHabit(
    CreateHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    final result = await createHabit(CreateHabitParams(habit: event.habit));

    result.fold(
      (failure) => emit(HabitError(failure.message)),
      (_) => add(LoadHabitsEvent()),
    );
  }

  Future<void> _onUpdateHabit(
    UpdateHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    final result = await updateHabit(UpdateHabitParams(habit: event.habit));

    result.fold(
      (failure) => emit(HabitError(failure.message)),
      (_) => add(LoadHabitsEvent()),
    );
  }

  Future<void> _onDeleteHabit(
    DeleteHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    final result = await deleteHabit(DeleteHabitParams(habitId: event.habitId));

    result.fold(
      (failure) => emit(HabitError(failure.message)),
      (_) => add(LoadHabitsEvent()),
    );
  }

  Future<void> _onToggleCompletion(
    ToggleCompletionEvent event,
    Emitter<HabitState> emit,
  ) async {
    final result = await toggleCompletion(
      ToggleCompletionParams(habitId: event.habitId),
    );

    result.fold(
      (failure) => emit(HabitError(failure.message)),
      (_) => add(LoadHabitsEvent()),
    );
  }
}
