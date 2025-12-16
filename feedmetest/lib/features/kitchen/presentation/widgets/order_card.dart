import 'dart:async';

import 'package:feedmetest/features/kitchen/controller/kitchen_cubit.dart';
import 'package:feedmetest/features/kitchen/model/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  Timer? _timer;
  int _countdown = 10;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startProcessing() {
    if (widget.order.status == OrderStatus.pending) {
      context.read<KitchenCubit>().processOrder(widget.order.id);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_countdown > 1) {
          setState(() {
            _countdown--;
          });
        } else {
          _timer?.cancel();
          context.read<KitchenCubit>().completeOrder(widget.order.id);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: _getCardColor(widget.order.status),
      child: ListTile(
        leading: Text(
          '#${widget.order.id}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        title: Text(
          widget.order.isVip ? 'VIP Order' : 'Regular Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.order.isVip ? Colors.amber[800] : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.order.items
              .map((item) => Text('${item.menuItem.name} (x${item.quantity})'))
              .toList(),
        ),
        trailing: _buildTrailingWidget(),
      ),
    );
  }

  Widget _buildTrailingWidget() {
    switch (widget.order.status) {
      case OrderStatus.pending:
        return ElevatedButton(
          onPressed: _startProcessing,
          child: const Text('Process'),
        );
      case OrderStatus.processing:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Processing...', style: TextStyle(color: Colors.blue[800])),
            Text('$_countdown s', style: Theme.of(context).textTheme.titleMedium),
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
