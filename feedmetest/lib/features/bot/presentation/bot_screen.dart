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
      body: const BotView(),
    );
  }
}

class BotView extends StatefulWidget {
  const BotView({super.key});

  @override
  State<BotView> createState() => _BotViewState();
}

class _BotViewState extends State<BotView> {
  late int _pendingBotCount;

  @override
  void initState() {
    super.initState();
    _pendingBotCount = context.read<BotCubit>().state.numberOfBots;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BotCubit, BotState>(
      listener: (context, state) {
        setState(() {
          _pendingBotCount = state.numberOfBots;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (_pendingBotCount > 1) {
                      setState(() {
                        _pendingBotCount--;
                      });
                    }
                  },
                ),
                Text(
                  '$_pendingBotCount',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _pendingBotCount++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<BotCubit>().setNumberOfBots(_pendingBotCount);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Number of bots updated.'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
