import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../utils/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carrito',
          style: TextStyle(
            fontFamily: 'League Spartan',
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(
        () => cartController.items.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_outlined,
                        size: 64, color: AppColors.lightGrey),
                    const SizedBox(height: 16),
                    Text(
                      'Tu carrito está vacío',
                      style: TextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Continuar comprando'),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartController.items.length,
                      itemBuilder: (context, index) {
                        final item = cartController.items[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Text(
                                  item.food.imageUrl,
                                  style: const TextStyle(fontSize: 40),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.food.name,
                                        style: TextStyles.heading3,
                                      ),
                                      Text(
                                        '\$${item.food.price.toStringAsFixed(2)}',
                                        style: TextStyles.price,
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove,
                                          color: AppColors.secondary),
                                      onPressed: () {
                                        cartController.updateQuantity(
                                          item.food.id,
                                          item.quantity - 1,
                                        );
                                      },
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        '${item.quantity}',
                                        style: TextStyles.heading3,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add,
                                          color: AppColors.secondary),
                                      onPressed: () {
                                        cartController.updateQuantity(
                                          item.food.id,
                                          item.quantity + 1,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Subtotal:',
                              style: TextStyle(
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Obx(() => Text(
                                  '\$${cartController.subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Envío:',
                              style: TextStyle(
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Obx(() => Text(
                                  '\$${cartController.deliveryFee.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Impuesto (10%):',
                              style: TextStyle(
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Obx(() => Text(
                                  '\$${cartController.tax.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Obx(() => Text(
                                  '\$${cartController.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondary,
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed('/checkout'),
                            child: const Text(
                              'Proceder al pago',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
