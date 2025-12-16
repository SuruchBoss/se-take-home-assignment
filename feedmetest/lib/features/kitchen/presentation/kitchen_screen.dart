import 'package:feedmetest/features/kitchen/controller/kitchen_cubit.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_state.dart';
import 'package:feedmetest/features/kitchen/model/order.dart';
import 'package:feedmetest/features/kitchen/presentation/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KitchenScreen extends StatelessWidget {
  const KitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Orders'),
      ),
      body: BlocBuilder<KitchenCubit, KitchenState>(
        builder: (context, state) {
          if (state is KitchenOrdersUpdated) {
            final pendingOrders = state.orders
                .where((order) => order.status != OrderStatus.completed)
                .toList();
            final completedOrders = state.orders
                .where((order) => order.status == OrderStatus.completed)
                .toList()
              ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

            if (pendingOrders.isEmpty && completedOrders.isEmpty) {
              return const Center(child: Text('No orders in the queue.'));
            }

            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Pending/Processing',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return OrderCard(order: pendingOrders[index]);
                    },
                    childCount: pendingOrders.length,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Completed',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return OrderCard(order: completedOrders[index]);
                    },
                    childCount: completedOrders.length,
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('No orders in the queue.'));
        },
      ),
    );
  }
}
