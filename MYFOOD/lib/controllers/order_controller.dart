import 'package:get/get.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import 'dart:async';

class OrderController extends GetxController {
  final currentOrder = Rx<Order?>(null);
  final orders = <Order>[].obs;
  late Timer _statusTimer;

  void createOrder(List<CartItem> items, double total,
      String deliveryAddress, String phoneNumber) {
    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: items,
      total: total,
      deliveryAddress: deliveryAddress,
      phoneNumber: phoneNumber,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      estimatedDeliveryMinutes: 45,
    );

    currentOrder.value = order;
    orders.add(order);

    // Simular cambio de estado
    _simulateOrderStatusChanges();
  }

  void _simulateOrderStatusChanges() {
    int statusIndex = 0;
    final statuses = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.onTheWay,
      OrderStatus.delivered,
    ];

    _statusTimer = Timer.periodic(Duration(seconds: 8), (timer) {
      if (statusIndex < statuses.length) {
        if (currentOrder.value != null) {
          currentOrder.value = Order(
            id: currentOrder.value!.id,
            items: currentOrder.value!.items,
            total: currentOrder.value!.total,
            deliveryAddress: currentOrder.value!.deliveryAddress,
            phoneNumber: currentOrder.value!.phoneNumber,
            status: statuses[statusIndex],
            createdAt: currentOrder.value!.createdAt,
            estimatedDeliveryMinutes: currentOrder.value!.estimatedDeliveryMinutes,
          );
          currentOrder.refresh();
        }
        statusIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  void cancelOrder() {
    _statusTimer.cancel();
    currentOrder.value = null;
  }

  @override
  void onClose() {
    if (_statusTimer.isActive) {
      _statusTimer.cancel();
    }
    super.onClose();
  }
}
