import 'dart:async';
import 'dart:math';
import 'package:feedmetest/features/bot/controller/bot_cubit.dart';
import 'package:feedmetest/features/cart/model/cart_item.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_state.dart';
import 'package:feedmetest/features/kitchen/model/order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KitchenCubit extends Cubit<KitchenState> {
  final BotCubit _botCubit;
  late final StreamSubscription _botSubscription;
  final Map<String, Timer> _orderTimers = {};

  int _previousBotCount;

  KitchenCubit(this._botCubit)
      : _previousBotCount = _botCubit.state.numberOfBots,
        super(const KitchenInitial()) {
    _botSubscription = _botCubit.stream.listen((botState) {
      if (botState.numberOfBots < _previousBotCount) {
        _handleBotReduction(botState.numberOfBots);
      } else {
        _processNextOrder();
      }
      _previousBotCount = botState.numberOfBots;
    });
  }

  final List<Order> _orders = [];

  void addOrder(List<CartItem> items, bool isVip) {
    final newOrder = Order(
      id: Random().nextInt(10000).toString(), // simple id generation
      items: List.from(items),
      isVip: isVip,
      timestamp: DateTime.now(),
      status: OrderStatus.pending,
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
    _processNextOrder();
  }

  void _handleBotReduction(int newBotCount) {
    final processingOrders = _orders
        .where((order) => order.status == OrderStatus.processing)
        .toList();
    final difference = processingOrders.length - newBotCount;

    if (difference > 0) {
      processingOrders.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      final ordersToRevert = processingOrders.take(difference);

      for (final order in ordersToRevert) {
        final orderIndex = _orders.indexWhere((o) => o.id == order.id);
        if (orderIndex != -1) {
          _orders[orderIndex] =
              _orders[orderIndex].copyWith(status: OrderStatus.pending);
          _orderTimers.remove(order.id)?.cancel();
        }
      }

      _orders.sort((a, b) {
        if (a.isVip && !b.isVip) {
          return -1;
        }
        if (!a.isVip && b.isVip) {
          return 1;
        }
        return a.timestamp.compareTo(b.timestamp);
      });

      emit(KitchenOrdersUpdated(List.from(_orders)));
    }
  }

  void _processNextOrder() {
    while (true) {
      final processingCount = _orders
          .where((order) => order.status == OrderStatus.processing)
          .length;
      final availableBots = _botCubit.state.numberOfBots;

      if (processingCount < availableBots) {
        final pendingOrderIndex =
            _orders.indexWhere((order) => order.status == OrderStatus.pending);
        if (pendingOrderIndex != -1) {
          final order = _orders[pendingOrderIndex];
          _orders[pendingOrderIndex] =
              order.copyWith(status: OrderStatus.processing);
          _startOrderTimer(order.id);
          emit(KitchenOrdersUpdated(List.from(_orders)));
        } else {
          break;
        }
      } else {
        break;
      }
    }
  }

  void _startOrderTimer(String orderId) {
    _orderTimers[orderId] = Timer(const Duration(seconds: 30), () {
      completeOrder(orderId);
    });
  }

  void completeOrder(String orderId) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final order = _orders[orderIndex];
      _orders[orderIndex] = order.copyWith(status: OrderStatus.completed);
      _orderTimers.remove(orderId)?.cancel();
      emit(KitchenOrdersUpdated(List.from(_orders)));
      _processNextOrder();
    }
  }

  @override
  Future<void> close() {
    _botSubscription.cancel();
    for (var timer in _orderTimers.values) {
      timer.cancel();
    }
    return super.close();
  }
}
