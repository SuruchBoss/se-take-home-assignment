import 'package:feedmetest/features/cart/controller/cart_cubit.dart';
import 'package:feedmetest/features/cart/controller/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/menu_cubit.dart';
import '../controller/menu_state.dart';
import 'widgets/queue_banner.dart';
import 'widgets/menu_item_card.dart';
import 'widgets/cart_icon_badge.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MenuCubit()..getMenuItems(),
      child: const MenuView(),
    );
  }
}

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [const CartIconBadge()],
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, menuState) {
          if (menuState is MenuLoading || menuState is MenuInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (menuState is MenuLoaded) {
            return BlocBuilder<CartCubit, CartState>(
                builder: (context, cartState) {
              if (cartState is CartLoaded) {
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: menuState.menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuState.menuItems[index];
                    final cartItem = cartState.cartItems.where((cartItem) => cartItem.menuItem.id == item.id);
                    final quantity = cartItem.isEmpty ? 0 : cartItem.first.quantity;

                    return MenuItemCard(item: item, quantity: quantity);
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            });
          }
          if (menuState is MenuError) {
            return Center(child: Text(menuState.message));
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
      persistentFooterButtons: [
        BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            if (state is MenuLoaded) {
              return QueueBanner(
                userQueue: state.userQueue,
                currentQueue: state.currentQueue,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
