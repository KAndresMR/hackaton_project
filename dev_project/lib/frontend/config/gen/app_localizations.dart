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

  /// App tagline shown below logo
  ///
  /// In en, this message translates to:
  /// **'Finance OS'**
  String get appTagline;

  /// Splash screen loading text
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get splashLoading;

  /// Title on the connect bank screen
  ///
  /// In en, this message translates to:
  /// **'Connect your bank'**
  String get connectBankTitle;

  /// Subtitle on the connect bank screen
  ///
  /// In en, this message translates to:
  /// **'Securely link a financial institution and let CredyNox monitor your cash flow automatically.'**
  String get connectBankSubtitle;

  /// Section label above bank list
  ///
  /// In en, this message translates to:
  /// **'Choose a bank'**
  String get connectBankChooseLabel;

  /// Security disclaimer below bank list
  ///
  /// In en, this message translates to:
  /// **'256-bit encrypted · Read-only access · No credentials stored'**
  String get connectBankSecurityNote;

  /// Status label when bank is already connected
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get bankCardStatusConnected;

  /// Status label when bank is selected and ready
  ///
  /// In en, this message translates to:
  /// **'Ready to connect'**
  String get bankCardStatusReady;

  /// Status label for unselected bank
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get bankCardStatusIdle;

  /// Button label for already-connected bank
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get bankCardBtnConnected;

  /// Button label to trigger connection
  ///
  /// In en, this message translates to:
  /// **'Connect now'**
  String get bankCardBtnConnect;

  /// Button label to select a bank
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get bankCardBtnSelect;

  /// Button label during connection process
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get bankCardBtnConnecting;

  /// Snackbar shown after successful bank connection
  ///
  /// In en, this message translates to:
  /// **'{bankName} connected successfully'**
  String connectBankSuccessSnackbar(String bankName);

  /// Error message when bank list fails to load
  ///
  /// In en, this message translates to:
  /// **'Could not load banks. Please try again.'**
  String get connectBankErrorLoad;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get connectBankRetry;

  /// Dashboard screen title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// Morning greeting
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get dashboardGreetingMorning;

  /// Afternoon greeting
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get dashboardGreetingAfternoon;

  /// Evening greeting
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get dashboardGreetingEvening;

  /// Title for the balance card
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get balanceCardTitle;

  /// Monthly change label
  ///
  /// In en, this message translates to:
  /// **'{sign}{percent}% this month'**
  String balanceCardChange(String sign, String percent);

  /// Title for liquidity card
  ///
  /// In en, this message translates to:
  /// **'Liquidity'**
  String get liquidityCardTitle;

  /// Available label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get liquidityCardAvailable;

  /// Reserved label
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get liquidityCardReserved;

  /// Title for automation status card
  ///
  /// In en, this message translates to:
  /// **'Automations'**
  String get automationCardTitle;

  /// Active rules count
  ///
  /// In en, this message translates to:
  /// **'{count} rules active'**
  String automationCardActive(int count);

  /// Last run timestamp
  ///
  /// In en, this message translates to:
  /// **'Last run {time}'**
  String automationCardLastRun(String time);

  /// Title for the timeline card
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get timelineCardTitle;

  /// Nav item label
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// Nav item label
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get navAccounts;

  /// Nav item label
  ///
  /// In en, this message translates to:
  /// **'Automate'**
  String get navAutomate;

  /// Nav item label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Nav sidebar item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Nav sidebar item
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get navHelp;

  /// Nav sidebar item
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get navTimeline;

  /// Nav sidebar item
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get navAnalytics;
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
