import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'CredyNox'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Finance OS'**
  String get appTagline;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get splashLoading;

  /// No description provided for @genericBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get genericBack;

  /// No description provided for @genericRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get genericRetry;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get statusDisabled;

  /// No description provided for @statusQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get statusQueued;

  /// No description provided for @statusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get statusAvailable;

  /// No description provided for @connectBankTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect your bank'**
  String get connectBankTitle;

  /// No description provided for @connectBankSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Securely link a financial institution and let CredyNox monitor your cash flow automatically.'**
  String get connectBankSubtitle;

  /// No description provided for @connectBankChooseLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose a bank'**
  String get connectBankChooseLabel;

  /// No description provided for @connectBankSecurityNote.
  ///
  /// In en, this message translates to:
  /// **'256-bit encrypted · Read-only access · No credentials stored'**
  String get connectBankSecurityNote;

  /// No description provided for @bankCardStatusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get bankCardStatusConnected;

  /// No description provided for @bankCardStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to connect'**
  String get bankCardStatusReady;

  /// No description provided for @bankCardStatusIdle.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get bankCardStatusIdle;

  /// No description provided for @bankCardBtnConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get bankCardBtnConnected;

  /// No description provided for @bankCardBtnConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect now'**
  String get bankCardBtnConnect;

  /// No description provided for @bankCardBtnSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get bankCardBtnSelect;

  /// No description provided for @bankCardBtnConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get bankCardBtnConnecting;

  /// No description provided for @connectBankSuccessSnackbar.
  ///
  /// In en, this message translates to:
  /// **'{bankName} connected successfully'**
  String connectBankSuccessSnackbar(String bankName);

  /// No description provided for @connectBankErrorLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load banks. Please try again.'**
  String get connectBankErrorLoad;

  /// No description provided for @connectBankRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get connectBankRetry;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get dashboardGreetingMorning;

  /// No description provided for @dashboardGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get dashboardGreetingAfternoon;

  /// No description provided for @dashboardGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get dashboardGreetingEvening;

  /// No description provided for @balanceCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get balanceCardTitle;

  /// No description provided for @balanceCardChange.
  ///
  /// In en, this message translates to:
  /// **'{sign}{percent}% this month'**
  String balanceCardChange(String sign, String percent);

  /// No description provided for @liquidityCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Liquidity'**
  String get liquidityCardTitle;

  /// No description provided for @liquidityCardAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get liquidityCardAvailable;

  /// No description provided for @liquidityCardReserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get liquidityCardReserved;

  /// No description provided for @automationCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Automations'**
  String get automationCardTitle;

  /// No description provided for @automationCardActive.
  ///
  /// In en, this message translates to:
  /// **'{count} rules active'**
  String automationCardActive(int count);

  /// No description provided for @automationCardLastRun.
  ///
  /// In en, this message translates to:
  /// **'Last run {time}'**
  String automationCardLastRun(String time);

  /// No description provided for @timelineCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get timelineCardTitle;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get navAccounts;

  /// No description provided for @navAutomate.
  ///
  /// In en, this message translates to:
  /// **'Automate'**
  String get navAutomate;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get navHelp;

  /// No description provided for @navTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get navTimeline;

  /// No description provided for @navAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get navAnalytics;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileBanksTitle.
  ///
  /// In en, this message translates to:
  /// **'Connected institutions'**
  String get profileBanksTitle;

  /// No description provided for @profileBanksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Banks currently linked to the simulation engine.'**
  String get profileBanksSubtitle;

  /// No description provided for @profileStatOptimized.
  ///
  /// In en, this message translates to:
  /// **'Optimized money'**
  String get profileStatOptimized;

  /// No description provided for @profileStatBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get profileStatBalance;

  /// No description provided for @profileStatBanks.
  ///
  /// In en, this message translates to:
  /// **'Connected banks'**
  String get profileStatBanks;

  /// No description provided for @profileStatAI.
  ///
  /// In en, this message translates to:
  /// **'AI status'**
  String get profileStatAI;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile. Please try again.'**
  String get profileLoadError;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// No description provided for @activitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything the engine did, in chronological order.'**
  String get activitySubtitle;

  /// No description provided for @activityMetricToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get activityMetricToday;

  /// No description provided for @activityEventsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} events'**
  String activityEventsCount(int count);

  /// No description provided for @activityMetricIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get activityMetricIncome;

  /// No description provided for @activityMetricAutomations.
  ///
  /// In en, this message translates to:
  /// **'Automations'**
  String get activityMetricAutomations;

  /// No description provided for @activityMetricProtected.
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get activityMetricProtected;

  /// No description provided for @activityTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get activityTimelineTitle;

  /// No description provided for @activityTimelineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recent simulation and protection events.'**
  String get activityTimelineSubtitle;

  /// No description provided for @activityAmountView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get activityAmountView;

  /// No description provided for @activityLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load activity. Please try again.'**
  String get activityLoadError;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @analyticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A compact view of growth, retention, and cash efficiency.'**
  String get analyticsSubtitle;

  /// No description provided for @analyticsMetricSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings rate'**
  String get analyticsMetricSavings;

  /// No description provided for @analyticsMetricRunway.
  ///
  /// In en, this message translates to:
  /// **'Runway'**
  String get analyticsMetricRunway;

  /// No description provided for @analyticsMetricRisk.
  ///
  /// In en, this message translates to:
  /// **'Risk score'**
  String get analyticsMetricRisk;

  /// No description provided for @analyticsMetricROI.
  ///
  /// In en, this message translates to:
  /// **'Automation ROI'**
  String get analyticsMetricROI;

  /// No description provided for @analyticsChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash flow trend'**
  String get analyticsChartTitle;

  /// No description provided for @analyticsChartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days of inflow vs reserve movement.'**
  String get analyticsChartSubtitle;

  /// No description provided for @analyticsInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Top insights'**
  String get analyticsInsightsTitle;

  /// No description provided for @analyticsInsightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What the engine would recommend next.'**
  String get analyticsInsightsSubtitle;

  /// No description provided for @analyticsInsight1Title.
  ///
  /// In en, this message translates to:
  /// **'Increase reserve rate'**
  String get analyticsInsight1Title;

  /// No description provided for @analyticsInsight1Desc.
  ///
  /// In en, this message translates to:
  /// **'Current balance is {balance} · main institution: {bank}.'**
  String analyticsInsight1Desc(String balance, String bank);

  /// No description provided for @analyticsInsight2Title.
  ///
  /// In en, this message translates to:
  /// **'Reduce low-value subscriptions'**
  String get analyticsInsight2Title;

  /// No description provided for @analyticsInsight2Desc.
  ///
  /// In en, this message translates to:
  /// **'Cancel 2 recurring items to free ~\$180 per month.'**
  String get analyticsInsight2Desc;

  /// No description provided for @analyticsInsight3Title.
  ///
  /// In en, this message translates to:
  /// **'Trigger automation earlier'**
  String get analyticsInsight3Title;

  /// No description provided for @analyticsInsight3Desc.
  ///
  /// In en, this message translates to:
  /// **'Set the reserve rule to fire 8 hours sooner after payroll.'**
  String get analyticsInsight3Desc;

  /// No description provided for @analyticsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load analytics. Please try again.'**
  String get analyticsLoadError;

  /// No description provided for @automationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Automations'**
  String get automationsTitle;

  /// No description provided for @automationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rules that protect cash flow and move money automatically.'**
  String get automationsSubtitle;

  /// No description provided for @automationsOverviewCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of 4 automations enabled'**
  String automationsOverviewCount(int count);

  /// No description provided for @automationsOverviewDesc.
  ///
  /// In en, this message translates to:
  /// **'The engine reserves cash, pays bills, and watches thresholds in real time.'**
  String get automationsOverviewDesc;

  /// No description provided for @automationAutoReserveTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto reserve'**
  String get automationAutoReserveTitle;

  /// No description provided for @automationAutoReserveDesc.
  ///
  /// In en, this message translates to:
  /// **'Move salary into protected funds automatically.'**
  String get automationAutoReserveDesc;

  /// No description provided for @automationLiquidityTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart liquidity'**
  String get automationLiquidityTitle;

  /// No description provided for @automationLiquidityDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep enough available cash before payouts.'**
  String get automationLiquidityDesc;

  /// No description provided for @automationBillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto bills'**
  String get automationBillsTitle;

  /// No description provided for @automationBillsDesc.
  ///
  /// In en, this message translates to:
  /// **'Schedule utilities and subscriptions safely.'**
  String get automationBillsDesc;

  /// No description provided for @automationAITitle.
  ///
  /// In en, this message translates to:
  /// **'AI optimization'**
  String get automationAITitle;

  /// No description provided for @automationAIDesc.
  ///
  /// In en, this message translates to:
  /// **'Suggest better savings and transfer moments.'**
  String get automationAIDesc;

  /// No description provided for @automationRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Automation rules'**
  String get automationRulesTitle;

  /// No description provided for @automationRulesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review what the engine does when signals change.'**
  String get automationRulesSubtitle;

  /// No description provided for @automationRule1Title.
  ///
  /// In en, this message translates to:
  /// **'Salary detection'**
  String get automationRule1Title;

  /// No description provided for @automationRule1Desc.
  ///
  /// In en, this message translates to:
  /// **'Detect incoming salary, reserve funds, and update balances.'**
  String get automationRule1Desc;

  /// No description provided for @automationRule2Title.
  ///
  /// In en, this message translates to:
  /// **'Low balance alert'**
  String get automationRule2Title;

  /// No description provided for @automationRule2Desc.
  ///
  /// In en, this message translates to:
  /// **'Warn if liquidity drops below the configured threshold.'**
  String get automationRule2Desc;

  /// No description provided for @automationRule3Title.
  ///
  /// In en, this message translates to:
  /// **'Budget exceed block'**
  String get automationRule3Title;

  /// No description provided for @automationRule3Desc.
  ///
  /// In en, this message translates to:
  /// **'Mark spending bursts and recommend a reserve transfer.'**
  String get automationRule3Desc;

  /// No description provided for @automationsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load automations. Please try again.'**
  String get automationsLoadError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
