import 'package:dartz/dartz.dart';
import 'package:habit_flow/core/usecase/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit_with_stats.dart';
import '../repositories/habit_repository.dart';

class GetHabitsWithStats implements UseCase<List<HabitWithStats>, NoParams> {
  final HabitRepository repository;

  GetHabitsWithStats(this.repository);

  @override
  Future<Either<Failure, List<HabitWithStats>>> call(NoParams params) {
    return repository.getHabitsWithStats();
  }
}
