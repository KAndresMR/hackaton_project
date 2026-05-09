// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CredyNox';

  @override
  String get appTagline => 'Finance OS';

  @override
  String get splashLoading => 'Initializing...';

  @override
  String get connectBankTitle => 'Connect your bank';

  @override
  String get connectBankSubtitle =>
      'Securely link a financial institution and let CredyNox monitor your cash flow automatically.';

  @override
  String get connectBankChooseLabel => 'Choose a bank';

  @override
  String get connectBankSecurityNote =>
      '256-bit encrypted · Read-only access · No credentials stored';

  @override
  String get bankCardStatusConnected => 'Connected';

  @override
  String get bankCardStatusReady => 'Ready to connect';

  @override
  String get bankCardStatusIdle => 'Tap to select';

  @override
  String get bankCardBtnConnected => 'Connected';

  @override
  String get bankCardBtnConnect => 'Connect now';

  @override
  String get bankCardBtnSelect => 'Select';

  @override
  String get bankCardBtnConnecting => 'Connecting…';

  @override
  String connectBankSuccessSnackbar(String bankName) {
    return '$bankName connected successfully';
  }

  @override
  String get connectBankErrorLoad => 'Could not load banks. Please try again.';

  @override
  String get connectBankRetry => 'Retry';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardGreetingMorning => 'Good morning';

  @override
  String get dashboardGreetingAfternoon => 'Good afternoon';

  @override
  String get dashboardGreetingEvening => 'Good evening';

  @override
  String get balanceCardTitle => 'Total Balance';

  @override
  String balanceCardChange(String sign, String percent) {
    return '$sign$percent% this month';
  }

  @override
  String get liquidityCardTitle => 'Liquidity';

  @override
  String get liquidityCardAvailable => 'Available';

  @override
  String get liquidityCardReserved => 'Reserved';

  @override
  String get automationCardTitle => 'Automations';

  @override
  String automationCardActive(int count) {
    return '$count rules active';
  }

  @override
  String automationCardLastRun(String time) {
    return 'Last run $time';
  }

  @override
  String get timelineCardTitle => 'Recent Activity';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get navAutomate => 'Automate';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get navHelp => 'Help';

  @override
  String get navTimeline => 'Timeline';

  @override
  String get navAnalytics => 'Analytics';
}
