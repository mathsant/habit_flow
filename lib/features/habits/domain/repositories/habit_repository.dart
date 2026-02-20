import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit.dart';
import '../entities/habit_completion.dart';
import '../entities/habit_with_stats.dart';

abstract class HabitRepository {
  /// Retorna todos os hábitos com suas estatísticas
  Future<Either<Failure, List<HabitWithStats>>> getHabitsWithStats();

  /// Retorna as conclusões de um hábito nos últimos 7 dias
  Future<Either<Failure, List<HabitCompletion>>> getCompletionsForWeek(
    String habitId,
  );

  /// Cria um novo hábito
  Future<Either<Failure, Habit>> createHabit(Habit habit);

  /// Atualiza um hábito existente
  Future<Either<Failure, Habit>> updateHabit(Habit habit);

  /// Remove um hábito e todas as suas conclusões
  Future<Either<Failure, Unit>> deleteHabit(String habitId);

  /// Marca ou desmarca o hábito como concluído hoje
  Future<Either<Failure, Unit>> toggleCompletion(String habitId);
}
