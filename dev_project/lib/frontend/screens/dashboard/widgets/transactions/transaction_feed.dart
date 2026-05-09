import 'package:credynox/frontend/models/transaction_model.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';

import 'package:credynox/core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionFeed extends StatelessWidget {
  const TransactionFeed({super.key, required this.transactionsAsync});

  final AsyncValue<List<TransactionModel>> transactionsAsync;

  @override
  Widget build(BuildContext context) {
    return NxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NxCardHeader(
            title: 'RECENT TRANSACTIONS',
            subtitle: 'Backend-driven activity feed',
            icon: Icons.receipt_long_outlined,
            iconColor: AppColors.cyan,
          ),
          const SizedBox(height: 18),
          transactionsAsync.when(
            data: (transactions) {
              if (transactions.isEmpty) {
                return const Text('No transactions yet', style: TextStyle(color: AppColors.textSecondary));
              }

              return Column(
                children: transactions.take(4).map((transaction) {
                  final sign = transaction.amount >= 0 ? '+' : '-';
                  final color = transaction.amount >= 0 ? AppColors.emerald : AppColors.amber;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${transaction.type.toUpperCase()} • ${transaction.date.toLocal().toIso8601String().substring(0, 19)}',
                            style: const TextStyle(color: AppColors.textPrimary),
                          ),
                        ),
                        Text(
                          '$sign\$${transaction.amount.abs().toStringAsFixed(2)}',
                          style: TextStyle(color: color, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (error, _) => Text('Failed to load transactions: $error', style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 280.ms).slideY(begin: 0.08);
  }
}