import 'package:flutter/material.dart';

class OrderConfirmationDialog extends StatelessWidget {
  const OrderConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thank You!'),
      content: const Text('Your order has been sent to the kitchen and is being prepared.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
