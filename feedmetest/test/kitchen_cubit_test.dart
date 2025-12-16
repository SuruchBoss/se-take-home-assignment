import 'package:feedmetest/features/bot/controller/bot_cubit.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_cubit.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_state.dart';
import 'package:feedmetest/features/kitchen/model/order.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

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

    blocTest<KitchenCubit, KitchenState>(
      'adds a new order and sorts it',
      build: () => kitchenCubit,
      act: (cubit) {
        cubit.addOrder([], false);
        cubit.addOrder([], true);
      },
      verify: (cubit) {
        final state = cubit.state as KitchenOrdersUpdated;
        expect(state.orders.length, 2);
        expect(state.orders.first.isVip, true);
      },
    );

    blocTest<KitchenCubit, KitchenState>(
      'processes orders based on number of bots',
      build: () {
        botCubit.setNumberOfBots(2);
        return kitchenCubit;
      },
      act: (cubit) {
        cubit.addOrder([], false);
        cubit.addOrder([], false);
        cubit.addOrder([], false);
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        final state = cubit.state as KitchenOrdersUpdated;
        final processingOrders =
            state.orders.where((o) => o.status == OrderStatus.processing).toList();
        expect(processingOrders.length, 2);
      },
    );

    blocTest<KitchenCubit, KitchenState>(
      'completes an order and processes the next one',
      build: () {
        botCubit.setNumberOfBots(1);
        return kitchenCubit;
      },
      act: (cubit) async {
        cubit.addOrder([], false);
        await Future.delayed(const Duration(milliseconds: 100));
        // Manually complete the order as timer is mocked in test
        final orderId = (cubit.state as KitchenOrdersUpdated)
            .orders
            .firstWhere((o) => o.status == OrderStatus.processing)
            .id;
        cubit.completeOrder(orderId);
      },
      verify: (cubit) {
        final state = cubit.state as KitchenOrdersUpdated;
        final completedOrders =
            state.orders.where((o) => o.status == OrderStatus.completed).toList();
        expect(completedOrders.length, 1);
      },
    );

    blocTest<KitchenCubit, KitchenState>(
      'increases bots and processes more orders',
      build: () {
        botCubit.setNumberOfBots(1);
        return kitchenCubit;
      },
      act: (cubit) async {
        cubit.addOrder([], false);
        cubit.addOrder([], false);
        await Future.delayed(const Duration(milliseconds: 100));
        botCubit.setNumberOfBots(2);
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        final state = cubit.state as KitchenOrdersUpdated;
        final processingOrders =
            state.orders.where((o) => o.status == OrderStatus.processing).toList();
        expect(processingOrders.length, 2);
      },
    );

    blocTest<KitchenCubit, KitchenState>(
      'decreases bots and stops processing newest order',
      build: () {
        botCubit.setNumberOfBots(2);
        return kitchenCubit;
      },
      act: (cubit) async {
        cubit.addOrder([], false);
        cubit.addOrder([], false);
        await Future.delayed(const Duration(milliseconds: 100));
        botCubit.setNumberOfBots(1);
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        final state = cubit.state as KitchenOrdersUpdated;
        final processingOrders =
            state.orders.where((o) => o.status == OrderStatus.processing).toList();
        final pendingOrders =
            state.orders.where((o) => o.status == OrderStatus.pending).toList();
        expect(processingOrders.length, 1);
        expect(pendingOrders.length, 1);
      },
    );
  });
}
