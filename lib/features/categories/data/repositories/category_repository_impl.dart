import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDatasource datasource;

  CategoryRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await datasource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> createCategory(Category category) async {
    try {
      final model = await datasource.createCategory(category);
      return Right(model);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String categoryId) async {
    try {
      await datasource.deleteCategory(categoryId);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> seedDefaultCategories() async {
    try {
      await datasource.seedDefaultCategories();
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
