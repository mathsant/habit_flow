import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  /// Retorna todas as categorias
  Future<Either<Failure, List<Category>>> getCategories();

  /// Cria uma nova categoria
  Future<Either<Failure, Category>> createCategory(Category category);

  /// Remove uma categoria
  Future<Either<Failure, Unit>> deleteCategory(String categoryId);

  /// Popula as categorias padrão (chamado na inicialização)
  Future<Either<Failure, Unit>> seedDefaultCategories();
}
