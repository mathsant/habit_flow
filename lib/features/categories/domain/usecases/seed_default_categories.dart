import 'package:dartz/dartz.dart';
import 'package:habit_flow/core/usecase/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/category_repository.dart';

class SeedDefaultCategories implements UseCase<Unit, NoParams> {
  final CategoryRepository repository;

  SeedDefaultCategories(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.seedDefaultCategories();
  }
}
