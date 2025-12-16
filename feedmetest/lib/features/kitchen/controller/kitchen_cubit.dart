import 'dart:math';
import 'package:feedmetest/features/cart/model/cart_item.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_state.dart';
import 'package:feedmetest/features/kitchen/model/order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KitchenCubit extends Cubit<KitchenState> {
  KitchenCubit() : super(const KitchenInitial());

  final List<Order> _orders = [];

  void addOrder(List<CartItem> items, bool isVip) {
    final newOrder = Order(
      id: Random().nextInt(10000).toString(), // simple id generation
      items: List.from(items),
      isVip: isVip,
      timestamp: DateTime.now(),
    );

    _orders.add(newOrder);
    _orders.sort((a, b) {
      if (a.isVip && !b.isVip) {
        return -1; // a comes first
      }
      if (!a.isVip && b.isVip) {
        return 1; // b comes first
      }
      return a.timestamp.compareTo(b.timestamp); // FCFS for same priority
    });

    emit(KitchenOrdersUpdated(List.from(_orders)));
  }

  void completeOrder(String orderId) {
    _orders.removeWhere((order) => order.id == orderId);
    emit(KitchenOrdersUpdated(List.from(_orders)));
  }
}
