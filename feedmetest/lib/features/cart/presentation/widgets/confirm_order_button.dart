import 'package:feedmetest/features/cart/presentation/widgets/vip_member_dialog.dart';
import 'package:flutter/material.dart';

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
