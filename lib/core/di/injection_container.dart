import 'package:get_it/get_it.dart';
import 'package:habit_flow/features/categories/presentation/cubit/category_cubit.dart';
import 'package:habit_flow/features/habits/presentation/bloc/habit_bloc.dart';

import '../../features/categories/data/datasources/category_local_datasource.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/create_category.dart';
import '../../features/categories/domain/usecases/get_categories.dart';
import '../../features/categories/domain/usecases/seed_default_categories.dart';
import '../../features/habits/data/datasources/habit_local_datasource.dart';
import '../../features/habits/data/repositories/habit_repository_impl.dart';
import '../../features/habits/domain/repositories/habit_repository.dart';
import '../../features/habits/domain/usecases/create_habit.dart';
import '../../features/habits/domain/usecases/delete_habit.dart';
import '../../features/habits/domain/usecases/get_completions_for_week.dart';
import '../../features/habits/domain/usecases/get_habits_with_stats.dart';
import '../../features/habits/domain/usecases/toggle_completion.dart';
import '../../features/habits/domain/usecases/update_habit.dart';
import '../database/database_helper.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ─── Database ────────────────────────────────────────────
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // ─── Datasources ─────────────────────────────────────────
  sl.registerLazySingleton<CategoryLocalDatasource>(
    () => CategoryLocalDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<HabitLocalDatasource>(
    () => HabitLocalDatasourceImpl(sl()),
  );

  // ─── Repositories ────────────────────────────────────────
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<HabitRepository>(
    () => HabitRepositoryImpl(sl()),
  );

  // ─── Use Cases — Categories ──────────────────────────────
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => CreateCategory(sl()));
  sl.registerLazySingleton(() => SeedDefaultCategories(sl()));

  // ─── Use Cases — Habits ──────────────────────────────────
  sl.registerLazySingleton(() => GetHabitsWithStats(sl()));
  sl.registerLazySingleton(() => CreateHabit(sl()));
  sl.registerLazySingleton(() => UpdateHabit(sl()));
  sl.registerLazySingleton(() => DeleteHabit(sl()));
  sl.registerLazySingleton(() => ToggleCompletion(sl()));
  sl.registerLazySingleton(() => GetCompletionsForWeek(sl()));

  // ─── BLoC / Cubit ────────────────────────────────────────
  sl.registerFactory(
    () => CategoryCubit(
      getCategories: sl(),
      createCategory: sl(),
      seedDefaultCategories: sl(),
    ),
  );
  sl.registerFactory(
    () => HabitBloc(
      getHabitsWithStats: sl(),
      createHabit: sl(),
      updateHabit: sl(),
      deleteHabit: sl(),
      toggleCompletion: sl(),
    ),
  );
}
