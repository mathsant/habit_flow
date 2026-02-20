import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_flow/core/usecase/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit_completion.dart';
import '../repositories/habit_repository.dart';

class GetCompletionsForWeek
    implements UseCase<List<HabitCompletion>, GetCompletionsForWeekParams> {
  final HabitRepository repository;

  GetCompletionsForWeek(this.repository);

  @override
  Future<Either<Failure, List<HabitCompletion>>> call(
    GetCompletionsForWeekParams params,
  ) {
    return repository.getCompletionsForWeek(params.habitId);
  }
}

class GetCompletionsForWeekParams extends Equatable {
  final String habitId;

  const GetCompletionsForWeekParams({required this.habitId});

  @override
  List<Object> get props => [habitId];
}
