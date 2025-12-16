import 'package:feedmetest/features/bot/controller/bot_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BotScreen extends StatelessWidget {
  const BotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bot Management'),
      ),
      body: BlocProvider(
        create: (context) => BotCubit(),
        child: const BotView(),
      ),
    );
  }
}

class BotView extends StatefulWidget {
  const BotView({super.key});

  @override
  State<BotView> createState() => _BotViewState();
}

class _BotViewState extends State<BotView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<BotCubit>().state.numberOfBots.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Number of Bots',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final newCount = int.tryParse(_controller.text);
              if (newCount != null) {
                context.read<BotCubit>().setNumberOfBots(newCount);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Number of bots updated.'),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
