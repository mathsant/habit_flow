import 'package:equatable/equatable.dart';

class Habit extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String categoryId;
  final int colorIndex;
  final DateTime createdAt;

  const Habit({
    required this.id,
    required this.title,
    this.description,
    required this.categoryId,
    required this.colorIndex,
    required this.createdAt,
  });

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryId,
    int? colorIndex,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      colorIndex: colorIndex ?? this.colorIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    categoryId,
    colorIndex,
    createdAt,
  ];
}
