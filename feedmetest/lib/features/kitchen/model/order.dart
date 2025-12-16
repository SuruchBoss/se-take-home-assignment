import 'package:feedmetest/features/cart/model/cart_item.dart';
import 'package:flutter/foundation.dart';

enum OrderStatus { pending, processing, completed }

@immutable
class Order {
  final String id;
  final List<CartItem> items;
  final bool isVip;
  final DateTime timestamp;
  final OrderStatus status;

  const Order({
    required this.id,
    required this.items,
    required this.isVip,
    required this.timestamp,
    this.status = OrderStatus.pending,
  });

  Order copyWith({
    String? id,
    List<CartItem>? items,
    bool? isVip,
    DateTime? timestamp,
    OrderStatus? status,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      isVip: isVip ?? this.isVip,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}