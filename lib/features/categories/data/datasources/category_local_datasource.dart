import '../../../../core/database/database_helper.dart';
import '../../domain/entities/category.dart';
import '../../domain/utils/default_categories.dart';
import '../models/category_model.dart';

abstract class CategoryLocalDatasource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> createCategory(Category category);
  Future<void> deleteCategory(String categoryId);
  Future<void> seedDefaultCategories();
}

class CategoryLocalDatasourceImpl implements CategoryLocalDatasource {
  final DatabaseHelper databaseHelper;

  CategoryLocalDatasourceImpl(this.databaseHelper);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final db = await databaseHelper.database;
    final maps = await db.query('categories', orderBy: 'name ASC');
    return maps.map((m) => CategoryModel.fromMap(m)).toList();
  }

  @override
  Future<CategoryModel> createCategory(Category category) async {
    final db = await databaseHelper.database;
    final model = CategoryModel.fromEntity(category);
    await db.insert('categories', model.toMap());
    return model;
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    final db = await databaseHelper.database;
    await db.delete('categories', where: 'id = ?', whereArgs: [categoryId]);
  }

  @override
  Future<void> seedDefaultCategories() async {
    final db = await databaseHelper.database;
    final existing = await db.query('categories', limit: 1);

    // Só popula se o banco estiver vazio
    if (existing.isNotEmpty) return;

    final batch = db.batch();
    for (final category in DefaultCategories.values) {
      final model = CategoryModel.fromEntity(category);
      batch.insert('categories', model.toMap());
    }
    await batch.commit(noResult: true);
  }
}
