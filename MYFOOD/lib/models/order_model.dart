import 'cart_item_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  onTheWay,
  delivered,
}

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final String deliveryAddress;
  final String phoneNumber;
  final OrderStatus status;
  final DateTime createdAt;
  final int estimatedDeliveryMinutes;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.deliveryAddress,
    required this.phoneNumber,
    required this.status,
    required this.createdAt,
    required this.estimatedDeliveryMinutes,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.confirmed:
        return 'Confirmado';
      case OrderStatus.preparing:
        return 'Preparando';
      case OrderStatus.onTheWay:
        return 'En camino';
      case OrderStatus.delivered:
        return 'Entregado';
    }
  }
}
