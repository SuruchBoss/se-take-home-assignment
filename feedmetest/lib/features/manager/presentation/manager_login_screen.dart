import 'package:feedmetest/features/manager/presentation/manager_dashboard_screen.dart';
import 'package:flutter/material.dart';

class ManagerLoginScreen extends StatelessWidget {
  const ManagerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ManagerDashboardScreen()),
            );
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
