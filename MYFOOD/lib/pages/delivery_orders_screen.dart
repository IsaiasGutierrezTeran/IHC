import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/delivery_controller.dart';
import '../models/order_model.dart';
import '../utils/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';

class DeliveryOrdersScreen extends StatelessWidget {
  const DeliveryOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deliveryController = Get.find<DeliveryController>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary, size: 28),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'ORDENES',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Obx(
        () => Column(
          children: [
            // Pestañas
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => deliveryController.selectedTab.value = 'activas',
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: deliveryController.selectedTab.value == 'activas'
                              ? AppColors.secondary
                              : AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Activas (${deliveryController.acceptedOrders.length})',
                            style: TextStyle(
                              color: deliveryController.selectedTab.value == 'activas'
                                  ? AppColors.white
                                  : AppColors.mediumGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => deliveryController.selectedTab.value = 'pendientes',
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: deliveryController.selectedTab.value == 'pendientes'
                              ? AppColors.secondary
                              : AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Pendientes (${deliveryController.availableOrders.length})',
                            style: TextStyle(
                              color: deliveryController.selectedTab.value == 'pendientes'
                                  ? AppColors.white
                                  : AppColors.mediumGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => deliveryController.selectedTab.value = 'completadas',
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: deliveryController.selectedTab.value == 'completadas'
                              ? AppColors.secondary
                              : AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Completadas (${deliveryController.completedOrders.length})',
                            style: TextStyle(
                              color: deliveryController.selectedTab.value == 'completadas'
                                  ? AppColors.white
                                  : AppColors.mediumGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Contenido
            Expanded(
              child: _buildTabContent(deliveryController),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildTabContent(DeliveryController controller) {
    if (controller.selectedTab.value == 'pendientes') {
      return _buildPendingOrders(controller);
    } else if (controller.selectedTab.value == 'activas') {
      return _buildActiveOrders(controller);
    } else {
      return _buildCompletedOrders(controller);
    }
  }

  Widget _buildPendingOrders(DeliveryController controller) {
    if (controller.availableOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 64, color: AppColors.lightGrey),
            const SizedBox(height: 16),
            Text(
              'No hay órdenes pendientes',
              style: TextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: controller.availableOrders.length,
      itemBuilder: (context, index) {
        final order = controller.availableOrders[index];
        return _buildPendingOrderCard(order, controller);
      },
    );
  }

  Widget _buildPendingOrderCard(Order order, DeliveryController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            if (order.items.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  color: AppColors.black,
                  child: Image.network(
                    order.items.first.food.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primaryLight,
                        child: Icon(
                          Icons.restaurant,
                          size: 60,
                          color: AppColors.secondary,
                        ),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // Header con ID y precio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Orden #${order.id}',
                  style: TextStyles.heading3,
                ),
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: TextStyles.price,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Items
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: order.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${item.food.name} x${item.quantity}',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            // Dirección
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.secondary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.deliveryAddress,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Teléfono
            Row(
              children: [
                const Icon(Icons.phone, color: AppColors.secondary, size: 20),
                const SizedBox(width: 8),
                Text(
                  order.phoneNumber,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Botones
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.rejectOrder(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text('Rechazar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.acceptOrder(order),
                    child: const Text('Aceptar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveOrders(DeliveryController controller) {
    if (controller.acceptedOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_shipping_outlined, size: 64, color: AppColors.lightGrey),
            const SizedBox(height: 16),
            Text(
              'No hay entregas activas',
              style: TextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: controller.acceptedOrders.map((order) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildActiveOrderCard(order, controller),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActiveOrderCard(Order order, DeliveryController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            if (order.items.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  color: AppColors.primaryLight,
                  child: Image.network(
                    order.items.first.food.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primaryLight,
                        child: Icon(
                          Icons.restaurant,
                          size: 60,
                          color: AppColors.secondary,
                        ),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // Product name and price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.items.isNotEmpty ? order.items.first.food.name : 'Sin artículos',
                    style: TextStyles.heading3.copyWith(
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Date/Time
            Text(
              _formatDateTime(order.createdAt),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Delivery info
            Text(
              'Envío: Estimado en ${order.estimatedDeliveryMinutes} min',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            // Divider
            Container(
              height: 1,
              color: AppColors.lightGrey,
            ),
            const SizedBox(height: 16),
            // Customer info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, 
                        color: AppColors.secondary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order.deliveryAddress,
                          style: const TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, 
                        color: AppColors.secondary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        order.phoneNumber,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.startTracking(order);
                      Get.toNamed('/ubicacion');
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Seguimiento',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.startTracking(order);
                      Get.toNamed('/delivery-tracking');
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.secondary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Estado',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Hace unos segundos';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h ${difference.inMinutes % 60}m';
    } else {
      return '${dateTime.day} ${_getMonthName(dateTime.month)}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'pm' : 'am'}';
    }
  }

  String _getMonthName(int month) {
    const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return months[month - 1];
  }

  Widget _buildCompletedOrders(DeliveryController controller) {
    if (controller.completedOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 64, color: AppColors.lightGrey),
            const SizedBox(height: 16),
            Text(
              'No hay órdenes completadas',
              style: TextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: controller.completedOrders.length,
      itemBuilder: (context, index) {
        final order = controller.completedOrders[index];
        return _buildCompletedOrderCard(order);
      },
    );
  }

  Widget _buildCompletedOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            if (order.items.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  color: AppColors.primaryLight,
                  child: Image.network(
                    order.items.first.food.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primaryLight,
                        child: Icon(
                          Icons.restaurant,
                          size: 60,
                          color: AppColors.secondary,
                        ),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // Header con ID y precio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Orden #${order.id}',
                  style: TextStyles.heading3.copyWith(
                    color: AppColors.black,
                  ),
                ),
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: TextStyles.price.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Items
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: order.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${item.food.name} x${item.quantity}',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            // Dirección
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.secondary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.deliveryAddress,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '✓ Entrega Completada',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
