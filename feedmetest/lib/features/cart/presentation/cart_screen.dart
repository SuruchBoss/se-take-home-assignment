import 'package:feedmetest/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:feedmetest/features/cart/presentation/widgets/confirm_order_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/cart_cubit.dart';
import '../controller/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return const Center(
                child: Text('Your cart is empty.'),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = state.cartItems[index];
                      return CartItemWidget(cartItem: item);
                    },
                  ),
                ),
                ConfirmOrderButton(totalPrice: state.totalPrice),
              ],
            );
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}
