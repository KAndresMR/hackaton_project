import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: NxCard(
            child: Center(
              child: Text(
                'Accounts placeholder',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
