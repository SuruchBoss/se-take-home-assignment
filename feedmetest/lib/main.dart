import 'package:feedmetest/features/cart/controller/cart_cubit.dart';
import 'package:feedmetest/features/menu/presentation/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: MaterialApp(
        home: const MenuScreen(),
      ),
    );
  }
}
