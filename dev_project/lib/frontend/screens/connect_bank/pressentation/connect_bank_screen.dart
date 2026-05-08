import 'package:credynox/core/router/routes.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/services/api_service.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConnectBankScreen extends StatefulWidget {
  const ConnectBankScreen({super.key});

  @override
  State<ConnectBankScreen> createState() => _ConnectBankScreenState();
}

class _ConnectBankScreenState extends State<ConnectBankScreen> {
  late Future<List<dynamic>> _banksFuture;
  String? _selectedBank;
  bool _connecting = false;

  @override
  void initState() {
    super.initState();
    _banksFuture = ApiService.getBanks();
  }

  Future<void> _connectBank() async {
    final bankName = _selectedBank;
    if (bankName == null) return;

    setState(() => _connecting = true);
    try {
      await ApiService.connectBank(bankName);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$bankName connected successfully')),
      );
      if (!mounted) return;
      context.go(AppRoutes.dashboard);
    } finally {
      if (mounted) {
        setState(() => _connecting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: FutureBuilder<List<dynamic>>(
              future: _banksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const NxCard(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return NxCard(
                    child: Text(
                      'Failed to load banks: ${snapshot.error}',
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  );
                }

                final banks = snapshot.data ?? const [];
                return NxCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.dashboard),
                            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Connect your bank',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Securely link a financial institution and let CredyNox monitor your cash flow.',
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: banks.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        itemBuilder: (context, index) {
                          final bank = banks[index] as Map<String, dynamic>;
                          final name = bank['name']?.toString() ?? 'Bank';
                          final connected = bank['connected'] == true;
                          final selected = _selectedBank == name;

                          return GestureDetector(
                            onTap: connected
                                ? null
                                : () => setState(() => _selectedBank = name),
                            child: NxCard(
                              hoverable: true,
                              borderColor: connected || selected
                                  ? AppColors.cyan
                                  : AppColors.borderSubtle,
                              glowColor: connected || selected
                                  ? AppColors.cyanGlow
                                  : null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.account_balance_rounded, color: AppColors.cyan),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    connected ? 'Connected' : selected ? 'Ready to connect' : 'Tap to select',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                      onPressed: connected
                                          ? null
                                          : selected
                                              ? _connecting
                                                  ? null
                                                  : _connectBank
                                              : () => setState(() => _selectedBank = name),
                                      child: Text(connected ? 'Connected' : selected ? 'Connect now' : 'Select'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}