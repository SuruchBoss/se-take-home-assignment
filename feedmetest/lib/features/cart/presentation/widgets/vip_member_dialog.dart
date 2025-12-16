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
