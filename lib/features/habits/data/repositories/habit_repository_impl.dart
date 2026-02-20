import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_completion.dart';
import '../../domain/entities/habit_with_stats.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../domain/utils/streak_calculator.dart';
import '../datasources/habit_local_datasource.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDatasource datasource;

  HabitRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<HabitWithStats>>> getHabitsWithStats() async {
    try {
      final habits = await datasource.getHabits();
      final List<HabitWithStats> result = [];

      for (final habit in habits) {
        final completions = await datasource.getAllCompletions(habit.id);
        final dates = completions.map((c) => c.completedAt).toList();

        result.add(
          HabitWithStats(
            habit: habit,
            completions: completions,
            isCompletedToday: StreakCalculator.isCompletedToday(dates),
            currentStreak: StreakCalculator.calculate(dates),
          ),
        );
      }

      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HabitCompletion>>> getCompletionsForWeek(
    String habitId,
  ) async {
    try {
      final completions = await datasource.getCompletionsForWeek(habitId);
      return Right(completions);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Habit>> createHabit(Habit habit) async {
    try {
      final model = await datasource.createHabit(habit);
      return Right(model);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Habit>> updateHabit(Habit habit) async {
    try {
      final model = await datasource.updateHabit(habit);
      return Right(model);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteHabit(String habitId) async {
    try {
      await datasource.deleteHabit(habitId);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleCompletion(String habitId) async {
    try {
      await datasource.toggleCompletion(habitId);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
