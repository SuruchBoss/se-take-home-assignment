import 'package:feedmetest/features/kitchen/model/order.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class KitchenState {
  const KitchenState();
}

class KitchenInitial extends KitchenState {
  const KitchenInitial();
}

class KitchenOrdersUpdated extends KitchenState {
  final List<Order> orders;

  const KitchenOrdersUpdated(this.orders);
}
