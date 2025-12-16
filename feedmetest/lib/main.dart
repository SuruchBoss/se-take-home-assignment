import 'package:feedmetest/features/bot/controller/bot_cubit.dart';
import 'package:feedmetest/features/cart/controller/cart_cubit.dart';
import 'package:feedmetest/features/kitchen/controller/kitchen_cubit.dart';
import 'package:feedmetest/features/menu/presentation/menu_screen.dart';
import 'package:feedmetest/features/user/controller/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(create: (_) => BotCubit()),
        BlocProvider(
          create: (context) => KitchenCubit(context.read<BotCubit>()),
        ),
      ],
      child: MaterialApp(
        title: 'FeedMe Test',
        home: const MenuScreen(),
      ),
    );
  }
}
