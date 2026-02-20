import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_flow/core/usecase/usecase.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/create_category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/seed_default_categories.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategories getCategories;
  final CreateCategory createCategory;
  final SeedDefaultCategories seedDefaultCategories;

  CategoryCubit({
    required this.getCategories,
    required this.createCategory,
    required this.seedDefaultCategories,
  }) : super(CategoryInitial());

  Future<void> loadCategories() async {
    emit(CategoryLoading());

    final result = await getCategories(NoParams());

    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }

  Future<void> seed() async {
    final result = await seedDefaultCategories(NoParams());
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (_) => loadCategories(),
    );
  }
}
