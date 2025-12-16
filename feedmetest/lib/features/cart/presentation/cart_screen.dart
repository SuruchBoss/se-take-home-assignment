import 'package:feedmetest/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:feedmetest/features/user/controller/user_cubit.dart';
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

class ConfirmOrderButton extends StatelessWidget {
  const ConfirmOrderButton({super.key, required this.totalPrice});

  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: \$${totalPrice.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const VipMemberDialog(),
              );
            },
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }
}

class VipMemberDialog extends StatefulWidget {
  const VipMemberDialog({super.key});

  @override
  State<VipMemberDialog> createState() => _VipMemberDialogState();
}

class _VipMemberDialogState extends State<VipMemberDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Member ID'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        maxLength: 5,
        decoration: const InputDecoration(
          labelText: 'Member ID',
          counterText: '',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Skip logic
            context.read<UserCubit>().setVip(false);
            context.read<CartCubit>().clearCart();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: const Text('Skip'),
        ),
        ElevatedButton(
          onPressed: () {
            // Confirm logic
            if (_controller.text.length == 5) {
              context.read<UserCubit>().setVip(true);
              context.read<CartCubit>().clearCart();
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else {
              // Show an error or something
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a 5-digit member ID.')),
              );
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
