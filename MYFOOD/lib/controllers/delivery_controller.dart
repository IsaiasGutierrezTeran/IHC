import 'package:get/get.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../models/food_model.dart';

class DeliveryController extends GetxController {
  // Órdenes disponibles para entregar
  late RxList<Order> availableOrders = <Order>[].obs;
  late RxList<Order> acceptedOrders = <Order>[].obs;
  late RxList<Order> completedOrders = <Order>[].obs;
  
  // Orden actual en seguimiento
  late Rx<Order?> currentTrackingOrder = Rx<Order?>(null);
  
  late RxString selectedTab = 'activas'.obs;

  @override
  void onInit() {
    super.onInit();
    _generateMockOrders();
  }

  void _generateMockOrders() {
    // Crear órdenes de ejemplo
    final mockFood = Food(
      id: '1',
      name: 'Pollo Broaster',
      description: 'Delicioso pollo crujiente',
      price: 20.00,
      imageUrl: 'https://th.bing.com/th/id/R.14a3b5165ecf20316cad53b0d14c064c?rik=yHpe82ThF7%2b5bw&riu=http%3a%2f%2fwww.comedera.com%2fwp-content%2fuploads%2f2018%2f08%2fpollo-frito.jpg&ehk=M%2feXtlveCncmKosjhYScm6TgmsAnEnVi2lstbAyDObE%3d&risl=&pid=ImgRaw&r=0',
      category: 'Comidas',
      rating: 4.5,
      preparationTime: 10,
    );

    final order1 = Order(
      id: 'ORD-001',
      items: [
        CartItem(food: mockFood, quantity: 2),
      ],
      total: 40.00,
      deliveryAddress: 'Calle Principal 123, Apto 4B',
      phoneNumber: '+1234567890',
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      estimatedDeliveryMinutes: 25,
    );

    final order2 = Order(
      id: 'ORD-002',
      items: [
        CartItem(food: mockFood, quantity: 1),
      ],
      total: 20.00,
      deliveryAddress: 'Avenida Central 456',
      phoneNumber: '+0987654321',
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      estimatedDeliveryMinutes: 30,
    );

    final order3 = Order(
      id: 'ORD-003',
      items: [
        CartItem(food: mockFood, quantity: 3),
      ],
      total: 60.00,
      deliveryAddress: 'Plaza Mayor 789',
      phoneNumber: '+5555555555',
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      estimatedDeliveryMinutes: 20,
    );

    availableOrders.addAll([order1, order2, order3]);
  }

  void acceptOrder(Order order) {
    // Mover orden de disponibles a aceptadas
    availableOrders.remove(order);
    final acceptedOrder = Order(
      id: order.id,
      items: order.items,
      total: order.total,
      deliveryAddress: order.deliveryAddress,
      phoneNumber: order.phoneNumber,
      status: OrderStatus.confirmed,
      createdAt: order.createdAt,
      estimatedDeliveryMinutes: order.estimatedDeliveryMinutes,
    );
    acceptedOrders.add(acceptedOrder);
  }

  void rejectOrder(Order order) {
    availableOrders.remove(order);
  }

  void startTracking(Order order) {
    currentTrackingOrder.value = order;
    // Simular progreso del estado
    _simulateDeliveryProgress();
  }

  void _simulateDeliveryProgress() {
    if (currentTrackingOrder.value == null) return;
    
    int statusIndex = currentTrackingOrder.value!.status.index;
    
    Future.delayed(const Duration(seconds: 8), () {
      if (statusIndex < OrderStatus.delivered.index) {
        statusIndex++;
        final updatedOrder = Order(
          id: currentTrackingOrder.value!.id,
          items: currentTrackingOrder.value!.items,
          total: currentTrackingOrder.value!.total,
          deliveryAddress: currentTrackingOrder.value!.deliveryAddress,
          phoneNumber: currentTrackingOrder.value!.phoneNumber,
          status: OrderStatus.values[statusIndex],
          createdAt: currentTrackingOrder.value!.createdAt,
          estimatedDeliveryMinutes: currentTrackingOrder.value!.estimatedDeliveryMinutes,
        );
        currentTrackingOrder.value = updatedOrder;
        
        if (statusIndex < OrderStatus.delivered.index) {
          _simulateDeliveryProgress();
        } else {
          // Mover a completadas
          acceptedOrders.remove(currentTrackingOrder.value);
          completedOrders.add(updatedOrder);
        }
      }
    });
  }

  void clearTracking() {
    currentTrackingOrder.value = null;
  }

  List<Order> get activeOrders {
    return acceptedOrders;
  }

  List<Order> get pendingOrders {
    return availableOrders;
  }
}
