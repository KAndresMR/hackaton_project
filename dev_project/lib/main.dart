import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: CredyNoxApp(),
    ),
  );
}

class CredyNoxApp extends ConsumerWidget {
  const CredyNoxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CredyNox',
      debugShowCheckedModeBanner: false,

      routerConfig: router,

      themeMode: ThemeMode.dark,
      theme: AppTheme.dark,

    );
  }
}