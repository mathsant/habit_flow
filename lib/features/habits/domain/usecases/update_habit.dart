import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_flow/core/usecase/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class UpdateHabit implements UseCase<Habit, UpdateHabitParams> {
  final HabitRepository repository;

  UpdateHabit(this.repository);

  @override
  Future<Either<Failure, Habit>> call(UpdateHabitParams params) {
    return repository.updateHabit(params.habit);
  }
}

class UpdateHabitParams extends Equatable {
  final Habit habit;

  const UpdateHabitParams({required this.habit});

  @override
  List<Object> get props => [habit];
}
