import 'package:feedmetest/features/kitchen/model/order.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: _getCardColor(order.status),
      child: ListTile(
        leading: Text(
          '#${order.id}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        title: Text(
          order.isVip ? 'VIP Order' : 'Regular Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: order.isVip ? Colors.amber[800] : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: order.items
              .map((item) => Text('${item.menuItem.name} (x${item.quantity})'))
              .toList(),
        ),
        trailing: _buildTrailingWidget(context),
      ),
    );
  }

  Widget _buildTrailingWidget(BuildContext context) {
    switch (order.status) {
      case OrderStatus.pending:
        return const Text('Pending');
      case OrderStatus.processing:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Processing...', style: TextStyle(color: Colors.blue[800])),
          ],
        );
      case OrderStatus.completed:
        return Icon(Icons.check_circle, color: Colors.green[700], size: 40);
    }
  }

  Color? _getCardColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return null;
      case OrderStatus.processing:
        return Colors.blue[100];
      case OrderStatus.completed:
        return Colors.green[100];
    }
  }
}
