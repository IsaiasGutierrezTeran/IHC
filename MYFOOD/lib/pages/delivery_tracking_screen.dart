import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/delivery_controller.dart';
import '../models/order_model.dart';
import '../utils/app_theme.dart';

class DeliveryTrackingScreen extends StatelessWidget {
  const DeliveryTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deliveryController = Get.find<DeliveryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Entrega en Progreso',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkGrey),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () => deliveryController.currentTrackingOrder.value == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_shipping_outlined,
                        size: 64, color: AppColors.lightGrey),
                    const SizedBox(height: 16),
                    Text(
                      'No hay entrega en progreso',
                      style: TextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Volver'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información de la orden
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Orden #${deliveryController.currentTrackingOrder.value!.id}',
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
                                      'Total a entregar',
                                      style: TextStyle(
                                        color: AppColors.mediumGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '\$${deliveryController.currentTrackingOrder.value!.total.toStringAsFixed(2)}',
                                      style: TextStyles.price,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'Tiempo estimado',
                                      style: TextStyle(
                                        color: AppColors.mediumGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '${deliveryController.currentTrackingOrder.value!.estimatedDeliveryMinutes} min',
                                      style: TextStyles.heading3,
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
                    // Estado de la entrega
                    Text(
                      'Estado de la Entrega',
                      style: TextStyles.heading2,
                    ),
                    const SizedBox(height: 16),
                    _buildStatusTimeline(
                      deliveryController.currentTrackingOrder.value!.status,
                    ),
                    const SizedBox(height: 24),
                    // Información de contacto
                    Text(
                      'Cliente',
                      style: TextStyles.heading2,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Dirección
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: AppColors.secondary, size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Dirección',
                                        style: TextStyle(
                                          color: AppColors.mediumGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        deliveryController.currentTrackingOrder.value!
                                            .deliveryAddress,
                                        style: TextStyles.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Teléfono
                            Row(
                              children: [
                                const Icon(Icons.phone,
                                    color: AppColors.secondary, size: 24),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Teléfono',
                                      style: TextStyle(
                                        color: AppColors.mediumGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      deliveryController.currentTrackingOrder.value!
                                          .phoneNumber,
                                      style: TextStyles.bodyMedium,
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
                    // Items del pedido
                    Text(
                      'Ítems a Entregar',
                      style: TextStyles.heading2,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ...deliveryController.currentTrackingOrder.value!.items
                                .map((item) {
                              return Padding(
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
                                          item.food.name,
                                          style: TextStyles.heading3,
                                        ),
                                        Text(
                                          'Cantidad: ${item.quantity}',
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
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Botón de completar entrega
                    if (deliveryController.currentTrackingOrder.value!.status !=
                        OrderStatus.delivered)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // La entrega se completa automáticamente en el controlador
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Entrega en Progreso',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            '✓ Entrega Completada',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
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
