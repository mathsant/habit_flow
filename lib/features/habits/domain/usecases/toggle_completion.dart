import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_flow/core/usecase/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/habit_repository.dart';

class ToggleCompletion implements UseCase<Unit, ToggleCompletionParams> {
  final HabitRepository repository;

  ToggleCompletion(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ToggleCompletionParams params) {
    return repository.toggleCompletion(params.habitId);
  }
}

class ToggleCompletionParams extends Equatable {
  final String habitId;

  const ToggleCompletionParams({required this.habitId});

  @override
  List<Object> get props => [habitId];
}
