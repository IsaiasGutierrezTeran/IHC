import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/order_controller.dart';
import '../models/order_model.dart';
import '../utils/app_theme.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seguimiento',
          style: TextStyle(
            fontFamily: 'League Spartan',
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(
        () => orderController.currentOrder.value == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long_outlined,
                        size: 64, color: AppColors.lightGrey),
                    const SizedBox(height: 16),
                    Text(
                      'No hay pedidos activos',
                      style: TextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Get.offNamed('/'),
                      child: const Text('Volver al Menú'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info del pedido
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pedido #${orderController.currentOrder.value!.id}',
                              style: TextStyles.heading2,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Hora del pedido',
                                      style: TextStyle(
                                        color: AppColors.mediumGrey,
                                        fontSize: 12,
                                        fontFamily: 'League Spartan',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('HH:mm').format(
                                        orderController.currentOrder.value!
                                            .createdAt,
                                      ),
                                      style: TextStyles.heading3,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'Entrega estimada',
                                      style: TextStyle(
                                        color: AppColors.mediumGrey,
                                        fontSize: 12,
                                        fontFamily: 'League Spartan',
                                      ),
                                    ),
                                    Text(
                                      '${orderController.currentOrder.value!.estimatedDeliveryMinutes} min',
                                      style: TextStyles.price,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Estado del pedido
                    Text(
                      'Estado del pedido',
                      style: TextStyles.heading2,
                    ),
                    const SizedBox(height: 16),
                    _buildStatusTimeline(
                      orderController.currentOrder.value!.status,
                    ),
                    const SizedBox(height: 24),
                    // Dirección de entrega
                    Text(
                      'Dirección de Entrega',
                      style: TextStyles.heading2,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on,
                                color: AppColors.secondary),
                            const SizedBox(height: 8),
                            Text(
                              orderController
                                  .currentOrder.value!.deliveryAddress,
                              style: TextStyles.heading3,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Teléfono: ${orderController.currentOrder.value!.phoneNumber}',
                              style: TextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Resumen de pedido
                    Text(
                      'Resumen del Pedido',
                      style: TextStyles.heading2,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ...orderController.currentOrder.value!.items
                                .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${item.food.name} x${item.quantity}',
                                          style: TextStyles.heading3,
                                        ),
                                        Text(
                                          '\$${item.food.price.toStringAsFixed(2)}',
                                          style: TextStyles.bodySmall,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '\$${item.subtotal.toStringAsFixed(2)}',
                                      style: TextStyles.price,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$${orderController.currentOrder.value!.total.toStringAsFixed(2)}',
                                  style: TextStyles.price,
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
      ),
    );
  }

  Widget _buildStatusTimeline(OrderStatus status) {
    final statuses = [
      ('Confirmado', OrderStatus.confirmed),
      ('Preparando', OrderStatus.preparing),
      ('En camino', OrderStatus.onTheWay),
      ('Entregado', OrderStatus.delivered),
    ];

    return Column(
      children: List.generate(statuses.length, (index) {
        final isCompleted = status.index >= statuses[index].$2.index;
        final isActive = status.index == statuses[index].$2.index;

        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.secondary : AppColors.lightGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check,
                            color: AppColors.white, size: 20)
                        : Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    statuses[index].$1,
                    style: TextStyle(
                      fontFamily: 'League Spartan',
                      fontSize: 16,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? AppColors.secondary : AppColors.darkGrey,
                    ),
                  ),
                ),
              ],
            ),
            if (index < statuses.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  width: 2,
                  height: 30,
                  color: status.index > index
                      ? AppColors.secondary
                      : AppColors.lightGrey,
                ),
              ),
          ],
        );
      }),
    );
  }
}

