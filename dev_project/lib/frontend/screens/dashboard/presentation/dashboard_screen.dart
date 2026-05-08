import 'package:credynox/frontend/screens/dashboard/widgets/dashboard_grid.dart';
import 'package:flutter/material.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: DashboardGrid(),
      ),
    );
  }
}