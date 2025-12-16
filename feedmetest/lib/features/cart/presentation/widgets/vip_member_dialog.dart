import 'package:feedmetest/features/cart/controller/cart_state.dart';
import 'package:feedmetest/features/cart/presentation/widgets/order_confirmation_dialog.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feedmetest/features/user/controller/user_cubit.dart';
import 'package:feedmetest/features/cart/controller/cart_cubit.dart';

class VipMemberDialog extends StatefulWidget {
  const VipMemberDialog({super.key});

  @override
  State<VipMemberDialog> createState() => _VipMemberDialogState();
}

class _VipMemberDialogState extends State<VipMemberDialog> {
  final _controller = TextEditingController();

  void _showConfirmationDialog() {
    Navigator.of(context).pop(); // Dismiss the VipMemberDialog
    showDialog(
      context: context,
      builder: (_) => const OrderConfirmationDialog(),
      barrierDismissible: false,
    );
  }

  void _addOrderToKitchen(bool isVip) {
    final cartState = context.read<CartCubit>().state;
    if (cartState is CartLoaded) {
      context.read<KitchenCubit>().addOrder(cartState.cartItems, isVip);
    }
  }

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
            _addOrderToKitchen(false);
            context.read<CartCubit>().clearCart();
            _showConfirmationDialog();
          },
          child: const Text('Skip'),
        ),
        ElevatedButton(
          onPressed: () {
            // Confirm logic
            if (_controller.text.length == 5) {
              context.read<UserCubit>().setVip(true);
              _addOrderToKitchen(true);
              context.read<CartCubit>().clearCart();
              _showConfirmationDialog();
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
