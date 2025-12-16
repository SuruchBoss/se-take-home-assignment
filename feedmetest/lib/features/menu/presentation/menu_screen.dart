import 'package:feedmetest/features/bot/presentation/bot_screen.dart';
import 'package:feedmetest/features/cart/controller/cart_cubit.dart';
import 'package:feedmetest/features/cart/controller/cart_state.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_cubit.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_state.dart';
import 'package:feedmetest/features/kitchen/model/order.dart';
import 'package:feedmetest/features/kitchen/presentation/kitchen_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/menu_cubit.dart';
import '../controller/menu_state.dart';
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

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  int _clickCount = 0;
  bool _isManager = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            icon: Icon(
              _isManager
                  ? Icons.admin_panel_settings
                  : Icons.admin_panel_settings_outlined,
            ),
            color: _isManager ? Colors.yellow : Colors.blueGrey,
            onPressed: () {
              setState(() {
                _clickCount++;
                if (_clickCount == 5) {
                  _isManager = !_isManager;
                  _clickCount = 0;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isManager
                            ? 'You are now a Manager'
                            : 'You are no longer a Manager',
                      ),
                    ),
                  );
                }
              });
            },
          ),
          Visibility(
            visible: _isManager,
            child: IconButton(
              icon: const Icon(Icons.smart_toy),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const BotScreen()));
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.kitchen),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const KitchenScreen()));
            },
          ),
          const CartIconBadge(),
        ],
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: menuState.menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuState.menuItems[index];
                      final cartItem = cartState.cartItems.where(
                        (cartItem) => cartItem.menuItem.id == item.id,
                      );
                      final quantity = cartItem.isEmpty
                          ? 0
                          : cartItem.first.quantity;

                      return MenuItemCard(item: item, quantity: quantity);
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
          if (menuState is MenuError) {
            return Center(child: Text(menuState.message));
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
      persistentFooterButtons: [
        BlocBuilder<KitchenCubit, KitchenState>(
          builder: (context, state) {
            if (state is KitchenOrdersUpdated) {
              final pendingOrders = state.orders
                  .where((order) => order.status != OrderStatus.completed)
                  .toList();
              if (pendingOrders.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Order: #${pendingOrders.first.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Total Orders: ${pendingOrders.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

