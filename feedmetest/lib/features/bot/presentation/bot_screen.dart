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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BotCubit, BotState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (state.numberOfBots > 1) {
                    context
                        .read<BotCubit>()
                        .setNumberOfBots(state.numberOfBots - 1);
                  }
                },
              ),
              Text(
                '${state.numberOfBots}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  context
                      .read<BotCubit>()
                      .setNumberOfBots(state.numberOfBots + 1);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
