// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'CredyNox';

  @override
  String get appTagline => 'Finance OS';

  @override
  String get splashLoading => 'Inicializando...';

  @override
  String get connectBankTitle => 'Conecta tu banco';

  @override
  String get connectBankSubtitle =>
      'Vincula de forma segura una institución financiera y deja que CredyNox monitoree tu flujo de caja automáticamente.';

  @override
  String get connectBankChooseLabel => 'Elige un banco';

  @override
  String get connectBankSecurityNote =>
      'Cifrado de 256 bits · Acceso de solo lectura · Sin credenciales almacenadas';

  @override
  String get bankCardStatusConnected => 'Conectado';

  @override
  String get bankCardStatusReady => 'Listo para conectar';

  @override
  String get bankCardStatusIdle => 'Toca para seleccionar';

  @override
  String get bankCardBtnConnected => 'Conectado';

  @override
  String get bankCardBtnConnect => 'Conectar ahora';

  @override
  String get bankCardBtnSelect => 'Seleccionar';

  @override
  String get bankCardBtnConnecting => 'Conectando…';

  @override
  String connectBankSuccessSnackbar(String bankName) {
    return '$bankName conectado exitosamente';
  }

  @override
  String get connectBankErrorLoad =>
      'No se pudo cargar la lista de bancos. Intenta de nuevo.';

  @override
  String get connectBankRetry => 'Reintentar';

  @override
  String get dashboardTitle => 'Panel';

  @override
  String get dashboardGreetingMorning => 'Buenos días';

  @override
  String get dashboardGreetingAfternoon => 'Buenas tardes';

  @override
  String get dashboardGreetingEvening => 'Buenas noches';

  @override
  String get balanceCardTitle => 'Balance Total';

  @override
  String balanceCardChange(String sign, String percent) {
    return '$sign$percent% este mes';
  }

  @override
  String get liquidityCardTitle => 'Liquidez';

  @override
  String get liquidityCardAvailable => 'Disponible';

  @override
  String get liquidityCardReserved => 'Reservado';

  @override
  String get automationCardTitle => 'Automatizaciones';

  @override
  String automationCardActive(int count) {
    return '$count reglas activas';
  }

  @override
  String automationCardLastRun(String time) {
    return 'Última ejecución $time';
  }

  @override
  String get timelineCardTitle => 'Actividad reciente';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navAccounts => 'Cuentas';

  @override
  String get navAutomate => 'Automatizar';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get navHelp => 'Ayuda';

  @override
  String get navTimeline => 'Cronología';

  @override
  String get navAnalytics => 'Analíticas';
}
