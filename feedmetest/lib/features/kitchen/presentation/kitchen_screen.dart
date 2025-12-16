import 'package:feedmetest/features/kitchen/controller/kitchen_cubit.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KitchenScreen extends StatelessWidget {
  const KitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kitchen Orders')),
      body: BlocBuilder<KitchenCubit, KitchenState>(
        builder: (context, state) {
          if (state is KitchenOrdersUpdated) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('No orders in the queue.'));
            }
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Text(
                      '#${order.id}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    title: Text(
                      order.isVip ? 'VIP Order' : 'Regular Order',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: order.isVip ? Colors.amber : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: order.items
                          .map(
                            (item) => Text(
                              '${item.menuItem.name} (x${item.quantity})',
                            ),
                          )
                          .toList(),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        context.read<KitchenCubit>().completeOrder(order.id);
                      },
                      child: const Text('Complete'),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No orders in the queue.'));
        },
      ),
    );
  }
}
