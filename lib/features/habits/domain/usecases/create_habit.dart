import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_flow/core/usecase/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class CreateHabit implements UseCase<Habit, CreateHabitParams> {
  final HabitRepository repository;

  CreateHabit(this.repository);

  @override
  Future<Either<Failure, Habit>> call(CreateHabitParams params) {
    return repository.createHabit(params.habit);
  }
}

class CreateHabitParams extends Equatable {
  final Habit habit;

  const CreateHabitParams({required this.habit});

  @override
  List<Object> get props => [habit];
}
