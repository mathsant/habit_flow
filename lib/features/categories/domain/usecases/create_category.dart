import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:habit_flow/core/usecase/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class CreateCategory implements UseCase<Category, CreateCategoryParams> {
  final CategoryRepository repository;

  CreateCategory(this.repository);

  @override
  Future<Either<Failure, Category>> call(CreateCategoryParams params) {
    return repository.createCategory(params.category);
  }
}

class CreateCategoryParams extends Equatable {
  final Category category;

  const CreateCategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}
