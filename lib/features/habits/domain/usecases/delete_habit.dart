import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_flow/core/usecase/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/habit_repository.dart';

class DeleteHabit implements UseCase<Unit, DeleteHabitParams> {
  final HabitRepository repository;

  DeleteHabit(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteHabitParams params) {
    return repository.deleteHabit(params.habitId);
  }
}

class DeleteHabitParams extends Equatable {
  final String habitId;

  const DeleteHabitParams({required this.habitId});

  @override
  List<Object> get props => [habitId];
}
