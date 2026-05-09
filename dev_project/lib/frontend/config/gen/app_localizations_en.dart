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
  String get genericBack => 'Back';

  @override
  String get genericRetry => 'Retry';

  @override
  String get statusActive => 'Active';

  @override
  String get statusDisabled => 'Disabled';

  @override
  String get statusQueued => 'Queued';

  @override
  String get statusAvailable => 'Available';

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

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileBanksTitle => 'Connected institutions';

  @override
  String get profileBanksSubtitle =>
      'Banks currently linked to the simulation engine.';

  @override
  String get profileStatOptimized => 'Optimized money';

  @override
  String get profileStatBalance => 'Balance';

  @override
  String get profileStatBanks => 'Connected banks';

  @override
  String get profileStatAI => 'AI status';

  @override
  String get profileLoadError => 'Failed to load profile. Please try again.';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activitySubtitle =>
      'Everything the engine did, in chronological order.';

  @override
  String get activityMetricToday => 'Today';

  @override
  String activityEventsCount(int count) {
    return '$count events';
  }

  @override
  String get activityMetricIncome => 'Income';

  @override
  String get activityMetricAutomations => 'Automations';

  @override
  String get activityMetricProtected => 'Protected';

  @override
  String get activityTimelineTitle => 'Timeline';

  @override
  String get activityTimelineSubtitle =>
      'Recent simulation and protection events.';

  @override
  String get activityAmountView => 'View';

  @override
  String get activityLoadError => 'Failed to load activity. Please try again.';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsSubtitle =>
      'A compact view of growth, retention, and cash efficiency.';

  @override
  String get analyticsMetricSavings => 'Savings rate';

  @override
  String get analyticsMetricRunway => 'Runway';

  @override
  String get analyticsMetricRisk => 'Risk score';

  @override
  String get analyticsMetricROI => 'Automation ROI';

  @override
  String get analyticsChartTitle => 'Cash flow trend';

  @override
  String get analyticsChartSubtitle =>
      'Last 30 days of inflow vs reserve movement.';

  @override
  String get analyticsInsightsTitle => 'Top insights';

  @override
  String get analyticsInsightsSubtitle =>
      'What the engine would recommend next.';

  @override
  String get analyticsInsight1Title => 'Increase reserve rate';

  @override
  String analyticsInsight1Desc(String balance, String bank) {
    return 'Current balance is $balance · main institution: $bank.';
  }

  @override
  String get analyticsInsight2Title => 'Reduce low-value subscriptions';

  @override
  String get analyticsInsight2Desc =>
      'Cancel 2 recurring items to free ~\$180 per month.';

  @override
  String get analyticsInsight3Title => 'Trigger automation earlier';

  @override
  String get analyticsInsight3Desc =>
      'Set the reserve rule to fire 8 hours sooner after payroll.';

  @override
  String get analyticsLoadError =>
      'Failed to load analytics. Please try again.';

  @override
  String get automationsTitle => 'Automations';

  @override
  String get automationsSubtitle =>
      'Rules that protect cash flow and move money automatically.';

  @override
  String automationsOverviewCount(int count) {
    return '$count of 4 automations enabled';
  }

  @override
  String get automationsOverviewDesc =>
      'The engine reserves cash, pays bills, and watches thresholds in real time.';

  @override
  String get automationAutoReserveTitle => 'Auto reserve';

  @override
  String get automationAutoReserveDesc =>
      'Move salary into protected funds automatically.';

  @override
  String get automationLiquidityTitle => 'Smart liquidity';

  @override
  String get automationLiquidityDesc =>
      'Keep enough available cash before payouts.';

  @override
  String get automationBillsTitle => 'Auto bills';

  @override
  String get automationBillsDesc =>
      'Schedule utilities and subscriptions safely.';

  @override
  String get automationAITitle => 'AI optimization';

  @override
  String get automationAIDesc => 'Suggest better savings and transfer moments.';

  @override
  String get automationRulesTitle => 'Automation rules';

  @override
  String get automationRulesSubtitle =>
      'Review what the engine does when signals change.';

  @override
  String get automationRule1Title => 'Salary detection';

  @override
  String get automationRule1Desc =>
      'Detect incoming salary, reserve funds, and update balances.';

  @override
  String get automationRule2Title => 'Low balance alert';

  @override
  String get automationRule2Desc =>
      'Warn if liquidity drops below the configured threshold.';

  @override
  String get automationRule3Title => 'Budget exceed block';

  @override
  String get automationRule3Desc =>
      'Mark spending bursts and recommend a reserve transfer.';

  @override
  String get automationsLoadError =>
      'Failed to load automations. Please try again.';
}
