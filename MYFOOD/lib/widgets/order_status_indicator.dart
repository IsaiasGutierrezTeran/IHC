import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderStatusIndicator extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusIndicator({
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatusStep(
          title: 'Pedido Confirmado',
          isCompleted: status.index >= 0,
          isActive: status.index == 0,
        ),
        _StatusConnector(
          isCompleted: status.index > 0,
        ),
        _StatusStep(
          title: 'Preparando',
          isCompleted: status.index >= 2,
          isActive: status.index == 2,
        ),
        _StatusConnector(
          isCompleted: status.index > 2,
        ),
        _StatusStep(
          title: 'En Camino',
          isCompleted: status.index >= 3,
          isActive: status.index == 3,
        ),
        _StatusConnector(
          isCompleted: status.index > 3,
        ),
        _StatusStep(
          title: 'Entregado',
          isCompleted: status.index >= 4,
          isActive: status.index == 4,
        ),
      ],
    );
  }
}

class _StatusStep extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final bool isActive;

  const _StatusStep({
    required this.title,
    required this.isCompleted,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white)
                : Text(
                    '${step + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.orange : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  int get step => 0; // Simplificado
}

class _StatusConnector extends StatelessWidget {
  final bool isCompleted;

  const _StatusConnector({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        width: 2,
        height: 30,
        color: isCompleted ? Colors.green : Colors.grey.shade300,
      ),
    );
  }
}
