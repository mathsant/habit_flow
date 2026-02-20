import 'package:uuid/uuid.dart';
import '../../../../core/database/database_helper.dart';
import '../../domain/entities/habit.dart';
import '../models/habit_completion_model.dart';
import '../models/habit_model.dart';

abstract class HabitLocalDatasource {
  Future<List<HabitModel>> getHabits();
  Future<List<HabitCompletionModel>> getCompletionsForWeek(String habitId);
  Future<List<HabitCompletionModel>> getAllCompletions(String habitId);
  Future<HabitModel> createHabit(Habit habit);
  Future<HabitModel> updateHabit(Habit habit);
  Future<void> deleteHabit(String habitId);
  Future<void> toggleCompletion(String habitId);
}

class HabitLocalDatasourceImpl implements HabitLocalDatasource {
  final DatabaseHelper databaseHelper;

  HabitLocalDatasourceImpl(this.databaseHelper);

  @override
  Future<List<HabitModel>> getHabits() async {
    final db = await databaseHelper.database;
    final maps = await db.query('habits', orderBy: 'created_at DESC');
    return maps.map((m) => HabitModel.fromMap(m)).toList();
  }

  @override
  Future<List<HabitCompletionModel>> getCompletionsForWeek(
    String habitId,
  ) async {
    final db = await databaseHelper.database;
    final sevenDaysAgo = DateTime.now()
        .subtract(const Duration(days: 7))
        .toIso8601String();

    final maps = await db.query(
      'habit_completions',
      where: 'habit_id = ? AND completed_at >= ?',
      whereArgs: [habitId, sevenDaysAgo],
      orderBy: 'completed_at DESC',
    );

    return maps.map((m) => HabitCompletionModel.fromMap(m)).toList();
  }

  @override
  Future<List<HabitCompletionModel>> getAllCompletions(String habitId) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'habit_completions',
      where: 'habit_id = ?',
      whereArgs: [habitId],
      orderBy: 'completed_at DESC',
    );
    return maps.map((m) => HabitCompletionModel.fromMap(m)).toList();
  }

  @override
  Future<HabitModel> createHabit(Habit habit) async {
    final db = await databaseHelper.database;
    final model = HabitModel.fromEntity(habit);
    await db.insert('habits', model.toMap());
    return model;
  }

  @override
  Future<HabitModel> updateHabit(Habit habit) async {
    final db = await databaseHelper.database;
    final model = HabitModel.fromEntity(habit);
    await db.update(
      'habits',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
    return model;
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    final db = await databaseHelper.database;
    await db.delete('habits', where: 'id = ?', whereArgs: [habitId]);
  }

  @override
  Future<void> toggleCompletion(String habitId) async {
    final db = await databaseHelper.database;
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    // Verifica se já completou hoje
    final existing = await db.query(
      'habit_completions',
      where: 'habit_id = ? AND completed_at >= ? AND completed_at < ?',
      whereArgs: [
        habitId,
        todayStart.toIso8601String(),
        todayEnd.toIso8601String(),
      ],
    );

    if (existing.isNotEmpty) {
      // Se já completou, remove (toggle off)
      await db.delete(
        'habit_completions',
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      // Se não completou, marca como completo (toggle on)
      await db.insert('habit_completions', {
        'id': const Uuid().v4(),
        'habit_id': habitId,
        'completed_at': today.toIso8601String(),
      });
    }
  }
}
