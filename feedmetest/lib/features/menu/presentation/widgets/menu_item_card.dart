import 'package:feedmetest/features/menu/controller/menu_cubit.dart';
import 'package:feedmetest/features/menu/model/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({super.key, required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Image.network(item.imageUrl, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<MenuCubit>().addToCart(item);
              },
              child: const Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
