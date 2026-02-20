import 'package:uuid/uuid.dart';
import '../entities/category.dart';

class DefaultCategories {
  static final List<Category> values = [
    Category(
      id: const Uuid().v4(),
      name: 'Saúde',
      colorIndex: 1, // Verde
      icon: 'favorite',
    ),
    Category(
      id: const Uuid().v4(),
      name: 'Exercício',
      colorIndex: 4, // Azul
      icon: 'fitness_center',
    ),
    Category(
      id: const Uuid().v4(),
      name: 'Estudo',
      colorIndex: 0, // Roxo
      icon: 'menu_book',
    ),
    Category(
      id: const Uuid().v4(),
      name: 'Mindfulness',
      colorIndex: 6, // Violeta
      icon: 'self_improvement',
    ),
    Category(
      id: const Uuid().v4(),
      name: 'Finanças',
      colorIndex: 2, // Amarelo
      icon: 'savings',
    ),
    Category(
      id: const Uuid().v4(),
      name: 'Social',
      colorIndex: 5, // Rosa
      icon: 'people',
    ),
    Category(
      id: const Uuid().v4(),
      name: 'Criatividade',
      colorIndex: 3, // Vermelho
      icon: 'palette',
    ),
    Category(
      id: const Uuid().v4(),
      name: 'Outro',
      colorIndex: 7, // Teal
      icon: 'star',
    ),
  ];
}
