import 'package:get/get.dart';
import '../models/food_model.dart';
import '../models/cart_item_model.dart';

class CartController extends GetxController {
  final items = <CartItem>[].obs;

  double get subtotal =>
      items.fold(0, (total, item) => total + item.subtotal);

  double get deliveryFee => subtotal > 0 ? 2.50 : 0;

  double get tax => subtotal * 0.1;

  double get total => subtotal + deliveryFee + tax;

  void addToCart(Food food) {
    final existingItem = items.firstWhereOrNull((item) => item.food.id == food.id);

    if (existingItem != null) {
      existingItem.quantity++;
    } else {
      items.add(CartItem(food: food));
    }
    items.refresh();
  }

  void removeFromCart(String foodId) {
    items.removeWhere((item) => item.food.id == foodId);
  }

  void updateQuantity(String foodId, int quantity) {
    final item = items.firstWhereOrNull((item) => item.food.id == foodId);
    if (item != null) {
      if (quantity <= 0) {
        removeFromCart(foodId);
      } else {
        item.quantity = quantity;
      }
      items.refresh();
    }
  }

  void clearCart() {
    items.clear();
  }

  bool get isEmpty => items.isEmpty;
}
