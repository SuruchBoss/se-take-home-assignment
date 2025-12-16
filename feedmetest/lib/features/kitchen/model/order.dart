import 'package:feedmetest/features/cart/model/cart_item.dart';
import 'package:flutter/foundation.dart';

@immutable
class Order {
  final String id;
  final List<CartItem> items;
  final bool isVip;
  final DateTime timestamp;

  const Order({
    required this.id,
    required this.items,
    required this.isVip,
    required this.timestamp,
  });
}
