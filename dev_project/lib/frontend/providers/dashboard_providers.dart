import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/automation_event_model.dart';
import '../models/dashboard_model.dart';
import '../models/transaction_model.dart';
import '../services/automation_service.dart';
import '../services/dashboard_service.dart';
import '../services/transaction_service.dart';

final dashboardServiceProvider = Provider<DashboardService>((ref) => const DashboardService());
final transactionServiceProvider = Provider<TransactionService>((ref) => const TransactionService());
final automationServiceProvider = Provider<AutomationService>((ref) => const AutomationService());

final dashboardProvider = FutureProvider<DashboardModel>((ref) async {
  return ref.read(dashboardServiceProvider).fetchDashboard();
});

final transactionProvider = FutureProvider<List<TransactionModel>>((ref) async {
  return ref.read(transactionServiceProvider).fetchTransactions();
});

final automationProvider = FutureProvider<List<AutomationEventModel>>((ref) async {
  return ref.read(automationServiceProvider).fetchTimeline();
});
