import 'package:feedmetest/features/bot/controller/bot_cubit.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_cubit.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_state.dart';
import 'package:feedmetest/features/kitchen/model/order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KitchenCubit', () {
    late BotCubit botCubit;
    late KitchenCubit kitchenCubit;

    setUp(() {
      botCubit = BotCubit();
      kitchenCubit = KitchenCubit(botCubit);
    });

    test('initial state is KitchenInitial', () {
      expect(kitchenCubit.state, isA<KitchenInitial>());
    });

    test('processes orders automatically based on number of bots', () async {
      botCubit.setNumberOfBots(2);
      kitchenCubit.addOrder([], false);
      kitchenCubit.addOrder([], false);
      kitchenCubit.addOrder([], false);

      await Future.delayed(const Duration(milliseconds: 100));

      final state = kitchenCubit.state as KitchenOrdersUpdated;
      final processingOrders =
          state.orders.where((o) => o.status == OrderStatus.processing).toList();
      expect(processingOrders.length, 2);
    });

    test('handles bot reduction correctly', () async {
      botCubit.setNumberOfBots(2);
      kitchenCubit.addOrder([], false);
      kitchenCubit.addOrder([], false);

      await Future.delayed(const Duration(milliseconds: 100));

      var state = kitchenCubit.state as KitchenOrdersUpdated;
      var processingOrders =
          state.orders.where((o) => o.status == OrderStatus.processing).toList();
      expect(processingOrders.length, 2);

      botCubit.setNumberOfBots(1);
      await Future.delayed(const Duration(milliseconds: 100));

      state = kitchenCubit.state as KitchenOrdersUpdated;
      processingOrders =
          state.orders.where((o) => o.status == OrderStatus.processing).toList();
      final pendingOrders =
          state.orders.where((o) => o.status == OrderStatus.pending).toList();

      expect(processingOrders.length, 1);
      expect(pendingOrders.length, 1);
    });
  });
}