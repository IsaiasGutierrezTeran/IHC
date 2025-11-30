import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/food_model.dart';
import '../controllers/cart_controller.dart';
import '../utils/app_theme.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;

  const FoodCard({
    required this.food,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  food.imageUrl,
                  style: const TextStyle(fontSize: 50),
                ),
              ),
            ),
            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: TextStyles.heading3,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food.description,
                      style: TextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${food.price.toStringAsFixed(2)}',
                              style: TextStyles.price,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 12, color: AppColors.secondary),
                                const SizedBox(width: 4),
                                Text(
                                  food.rating.toString(),
                                  style: TextStyles.label,
                                ),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            cartController.addToCart(food);
                            Get.snackbar(
                              'Agregado',
                              '${food.name} añadido al carrito',
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 2),
                              backgroundColor: AppColors.secondary,
                              colorText: AppColors.white,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                          ),
                          child: const Text(
                            'Agregar',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'League Spartan',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
