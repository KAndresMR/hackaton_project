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
  String get genericBack => 'Volver';

  @override
  String get genericRetry => 'Reintentar';

  @override
  String get statusActive => 'Activo';

  @override
  String get statusDisabled => 'Desactivado';

  @override
  String get statusQueued => 'En cola';

  @override
  String get statusAvailable => 'Disponible';

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
  String get navDashboard => 'Panel';

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

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileBanksTitle => 'Instituciones conectadas';

  @override
  String get profileBanksSubtitle =>
      'Bancos actualmente vinculados al motor de simulación.';

  @override
  String get profileStatOptimized => 'Dinero optimizado';

  @override
  String get profileStatBalance => 'Balance';

  @override
  String get profileStatBanks => 'Bancos conectados';

  @override
  String get profileStatAI => 'Estado de IA';

  @override
  String get profileLoadError =>
      'No se pudo cargar el perfil. Intenta de nuevo.';

  @override
  String get activityTitle => 'Actividad';

  @override
  String get activitySubtitle =>
      'Todo lo que hizo el motor, en orden cronológico.';

  @override
  String get activityMetricToday => 'Hoy';

  @override
  String activityEventsCount(int count) {
    return '$count eventos';
  }

  @override
  String get activityMetricIncome => 'Ingresos';

  @override
  String get activityMetricAutomations => 'Automatizaciones';

  @override
  String get activityMetricProtected => 'Protegido';

  @override
  String get activityTimelineTitle => 'Cronología';

  @override
  String get activityTimelineSubtitle =>
      'Eventos recientes de simulación y protección.';

  @override
  String get activityAmountView => 'Ver';

  @override
  String get activityLoadError =>
      'No se pudo cargar la actividad. Intenta de nuevo.';

  @override
  String get analyticsTitle => 'Analíticas';

  @override
  String get analyticsSubtitle =>
      'Vista compacta de crecimiento, retención y eficiencia de caja.';

  @override
  String get analyticsMetricSavings => 'Tasa de ahorro';

  @override
  String get analyticsMetricRunway => 'Runway';

  @override
  String get analyticsMetricRisk => 'Puntaje de riesgo';

  @override
  String get analyticsMetricROI => 'ROI de automatización';

  @override
  String get analyticsChartTitle => 'Tendencia de flujo de caja';

  @override
  String get analyticsChartSubtitle =>
      'Últimos 30 días de entradas vs movimiento de reservas.';

  @override
  String get analyticsInsightsTitle => 'Mejores insights';

  @override
  String get analyticsInsightsSubtitle =>
      'Lo que el motor recomendaría a continuación.';

  @override
  String get analyticsInsight1Title => 'Aumenta la tasa de reserva';

  @override
  String analyticsInsight1Desc(String balance, String bank) {
    return 'Balance actual $balance · institución principal: $bank.';
  }

  @override
  String get analyticsInsight2Title => 'Reduce suscripciones de bajo valor';

  @override
  String get analyticsInsight2Desc =>
      'Cancela 2 ítems recurrentes para liberar ~\$180 al mes.';

  @override
  String get analyticsInsight3Title => 'Activa la automatización antes';

  @override
  String get analyticsInsight3Desc =>
      'Configura la regla de reserva para dispararse 8 horas antes del nómina.';

  @override
  String get analyticsLoadError =>
      'No se pudieron cargar las analíticas. Intenta de nuevo.';

  @override
  String get automationsTitle => 'Automatizaciones';

  @override
  String get automationsSubtitle =>
      'Reglas que protegen el flujo de caja y mueven dinero automáticamente.';

  @override
  String automationsOverviewCount(int count) {
    return '$count de 4 automatizaciones activas';
  }

  @override
  String get automationsOverviewDesc =>
      'El motor reserva efectivo, paga facturas y vigila umbrales en tiempo real.';

  @override
  String get automationAutoReserveTitle => 'Auto reserva';

  @override
  String get automationAutoReserveDesc =>
      'Mueve el salario a fondos protegidos automáticamente.';

  @override
  String get automationLiquidityTitle => 'Liquidez inteligente';

  @override
  String get automationLiquidityDesc =>
      'Mantén suficiente efectivo disponible antes de los pagos.';

  @override
  String get automationBillsTitle => 'Pagos automáticos';

  @override
  String get automationBillsDesc =>
      'Programa servicios y suscripciones de forma segura.';

  @override
  String get automationAITitle => 'Optimización con IA';

  @override
  String get automationAIDesc =>
      'Sugiere mejores momentos para ahorrar y transferir.';

  @override
  String get automationRulesTitle => 'Reglas de automatización';

  @override
  String get automationRulesSubtitle =>
      'Revisa qué hace el motor cuando cambian las señales.';

  @override
  String get automationRule1Title => 'Detección de salario';

  @override
  String get automationRule1Desc =>
      'Detecta el salario entrante, reserva fondos y actualiza balances.';

  @override
  String get automationRule2Title => 'Alerta de saldo bajo';

  @override
  String get automationRule2Desc =>
      'Advierte si la liquidez cae por debajo del umbral configurado.';

  @override
  String get automationRule3Title => 'Bloqueo de presupuesto excedido';

  @override
  String get automationRule3Desc =>
      'Marca picos de gasto y recomienda una transferencia de reserva.';

  @override
  String get automationsLoadError =>
      'No se pudieron cargar las automatizaciones. Intenta de nuevo.';
}
