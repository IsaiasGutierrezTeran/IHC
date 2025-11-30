import 'package:get/get.dart';
import '../models/food_model.dart';

class MenuController extends GetxController {
  final foods = <Food>[].obs;
  final selectedCategory = 'Todos'.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFoods();
  }

  void loadFoods() {
    final mockFoods = [
      Food(
        id: '1',
        name: 'Hamburguesa Clásica',
        description: 'Pan integral con carne 100% de res',
        price: 8.99,
        category: 'Hamburguesas',
        imageUrl: '🍔',
        rating: 4.5,
        preparationTime: 15,
      ),
      Food(
        id: '2',
        name: 'Pizza Margarita',
        description: 'Tomate, mozzarella y albahaca fresca',
        price: 12.99,
        category: 'Pizzas',
        imageUrl: '🍕',
        rating: 4.8,
        preparationTime: 20,
      ),
      Food(
        id: '3',
        name: 'Ensalada César',
        description: 'Lechuga, pollo, aderezo César y queso',
        price: 9.99,
        category: 'Ensaladas',
        imageUrl: '🥗',
        rating: 4.3,
        preparationTime: 10,
      ),
      Food(
        id: '4',
        name: 'Sushi Mix',
        description: 'Variedad de rollos de sushi premium',
        price: 15.99,
        category: 'Asiática',
        imageUrl: '🍣',
        rating: 4.7,
        preparationTime: 25,
      ),
      Food(
        id: '5',
        name: 'Tacos al Pastor',
        description: 'Tres tacos con carne marinada',
        price: 7.99,
        category: 'Mexicana',
        imageUrl: '🌮',
        rating: 4.6,
        preparationTime: 12,
      ),
      Food(
        id: '6',
        name: 'Pasta Carbonara',
        description: 'Pasta con jamón, huevo y queso parmesano',
        price: 11.99,
        category: 'Pastas',
        imageUrl: '🍝',
        rating: 4.4,
        preparationTime: 18,
      ),
      Food(
        id: '7',
        name: 'Pollo BBQ',
        description: 'Pechuga de pollo con salsa BBQ casera',
        price: 10.99,
        category: 'Pollos',
        imageUrl: '🍗',
        rating: 4.5,
        preparationTime: 16,
      ),
      Food(
        id: '8',
        name: 'Batido de Fresa',
        description: 'Fresa, yogur y leche descremada',
        price: 4.99,
        category: 'Bebidas',
        imageUrl: '🥤',
        rating: 4.2,
        preparationTime: 5,
      ),
      Food(
        id: '9',
        name: 'Hamburguesa Doble',
        description: 'Doble carne, doble queso y bacon',
        price: 12.99,
        category: 'Hamburguesas',
        imageUrl: '🍔',
        rating: 4.7,
        preparationTime: 18,
      ),
      Food(
        id: '10',
        name: 'Pizza Pepperoni',
        description: 'Queso derretido con pepperoni premium',
        price: 13.99,
        category: 'Pizzas',
        imageUrl: '🍕',
        rating: 4.9,
        preparationTime: 22,
      ),
    ];
    foods.addAll(mockFoods);
  }

  List<Food> get filteredFoods {
    var filtered = foods.toList();

    if (selectedCategory.value != 'Todos') {
      filtered = filtered
          .where((food) => food.category == selectedCategory.value)
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((food) =>
              food.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  List<String> get categories {
    final cats = foods.map((food) => food.category).toSet().toList();
    return ['Todos', ...cats];
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void search(String query) {
    searchQuery.value = query;
  }
}

