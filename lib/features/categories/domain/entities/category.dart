import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final int colorIndex;
  final String icon;

  const Category({
    required this.id,
    required this.name,
    required this.colorIndex,
    required this.icon,
  });

  Category copyWith({
    String? id,
    String? name,
    int? colorIndex,
    String? icon,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      colorIndex: colorIndex ?? this.colorIndex,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object> get props => [id, name, colorIndex, icon];
}
