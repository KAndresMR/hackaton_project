import 'package:credynox/core/helpers/responsive.dart';
import 'package:credynox/core/router/routes.dart';
import 'package:credynox/core/theme/app_colors.dart';
import 'package:credynox/frontend/config/gen/app_localizations.dart';
import 'package:credynox/frontend/services/api_service.dart';
import 'package:credynox/frontend/widgets/nx_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

extension _L10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
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

  

  // ── Acción conectar ────────────────────────────────────────────────────────
  Future<void> _connectBank() async {
    final bankName = _selectedBank;
    if (bankName == null) return;

    setState(() => _connecting = true);
    try {
      await ApiService.connectBank(bankName);
      await Future.delayed(const Duration(seconds: 1)); // simulación
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.connectBankSuccessSnackbar(bankName)),
          backgroundColor: AppColors.bgElevated,
        ),
      );
      if (!mounted) return;
      context.go(AppRoutes.dashboard);
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  // ── Seleccionar banco ──────────────────────────────────────────────────────
  void _selectBank(String name) => setState(() => _selectedBank = name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      // SafeArea cubre notch/barra de estado en móvil
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            // Límite máximo en desktop para no estirarse demasiado
            constraints: const BoxConstraints(maxWidth: 820),
            child: Padding(
              // Padding horizontal adaptativo
              padding: ResponsiveHelper.pagePadding(context),
              child: FutureBuilder<List<dynamic>>(
                future: _banksFuture,
                builder: (context, snapshot) {
                  // ── Cargando ─────────────────────────────────────────────
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const _LoadingState();
                  }

                  // ── Error ─────────────────────────────────────────────────
                  if (snapshot.hasError) {
                    return _ErrorState(onRetry: () {
                      setState(() => _banksFuture = ApiService.getBanks());
                    });
                  }

                  final banks = snapshot.data ?? const [];

                  // ── Contenido principal ───────────────────────────────────
                  // NxCard.scroll() permite que todo el contenido (header +
                  // lista de bancos) sea scrollable sin desbordarse en móvil.
                  return NxCard.scroll(
                    padding: ResponsiveHelper.value(
                      context,
                      mobile: const EdgeInsets.all(20),
                      desktop: const EdgeInsets.all(32),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header ────────────────────────────────────────
                        _ConnectBankHeader(
                          onBack: () => context.canPop()
                              ? context.pop()
                              : context.go(AppRoutes.dashboard),
                        ),

                        const SizedBox(height: 28),

                        // ── Etiqueta sección ──────────────────────────────
                        Text(
                          context.l10n.connectBankChooseLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textTertiary,
                            letterSpacing: 1.2,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Lista de bancos ───────────────────────────────
                        // ResponsiveBuilder decide entre columna (móvil) y
                        // wrap de 2–3 columnas (tablet / desktop).
                        ResponsiveBuilder(
                          mobile: (_) => _BankColumn(
                            banks: banks,
                            selectedBank: _selectedBank,
                            connecting: _connecting,
                            onSelect: _selectBank,
                            onConnect: _connectBank,
                          ),
                          desktop: (_) => _BankWrap(
                            banks: banks,
                            selectedBank: _selectedBank,
                            connecting: _connecting,
                            onSelect: _selectBank,
                            onConnect: _connectBank,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Nota de seguridad ─────────────────────────────
                        const _SecurityNote(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ConnectBankHeader
// Título + subtítulo + botón back. Se extrae para que no se reconstruya
// cada vez que cambia _selectedBank o _connecting.
// ─────────────────────────────────────────────────────────────────────────────
class _ConnectBankHeader extends StatelessWidget {
  const _ConnectBankHeader({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botón volver
        GestureDetector(
          onTap: onBack,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_back_rounded,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Text(
                'Back',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Ícono + título
        Row(
          children: [
            NxIconBox(
              icon: Icons.account_balance_rounded,
              color: AppColors.cyan,
              size: 44,
              iconSize: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.connectBankTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.connectBankSubtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.03, duration: 400.ms);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _BankColumn  (móvil) — un card por fila, ocupa todo el ancho
// ─────────────────────────────────────────────────────────────────────────────
class _BankColumn extends StatelessWidget {
  const _BankColumn({
    required this.banks,
    required this.selectedBank,
    required this.connecting,
    required this.onSelect,
    required this.onConnect,
  });

  final List<dynamic> banks;
  final String? selectedBank;
  final bool connecting;
  final ValueChanged<String> onSelect;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < banks.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _BankCard(
            bank: banks[i],
            isSelected: selectedBank == banks[i]['name'],
            connecting: connecting && selectedBank == banks[i]['name'],
            onSelect: () => onSelect(banks[i]['name']),
            onConnect: onConnect,
          )
              .animate(delay: (60 * i).ms)
              .fadeIn(duration: 350.ms)
              .slideY(begin: 0.04, duration: 350.ms, curve: Curves.easeOut),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _BankWrap  (tablet/desktop) — 2 o 3 columnas con Wrap
// ─────────────────────────────────────────────────────────────────────────────
class _BankWrap extends StatelessWidget {
  const _BankWrap({
    required this.banks,
    required this.selectedBank,
    required this.connecting,
    required this.onSelect,
    required this.onConnect,
  });

  final List<dynamic> banks;
  final String? selectedBank;
  final bool connecting;
  final ValueChanged<String> onSelect;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    // Calculamos cuántas columnas caben según el ancho disponible
    final width = MediaQuery.sizeOf(context).width;
    final cols = width >= 900 ? 3 : 2;
    final spacing = 14.0;
    // Cada card ocupa (ancho_disponible - espacios) / columnas
    final cardWidth =
        (width.clamp(0, 820) - (32 * 2) - (spacing * (cols - 1))) / cols;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (int i = 0; i < banks.length; i++)
          SizedBox(
            width: cardWidth,
            child: _BankCard(
              bank: banks[i],
              isSelected: selectedBank == banks[i]['name'],
              connecting: connecting && selectedBank == banks[i]['name'],
              onSelect: () => onSelect(banks[i]['name']),
              onConnect: onConnect,
            )
                .animate(delay: (50 * i).ms)
                .fadeIn(duration: 300.ms)
                .slideY(begin: 0.03, duration: 300.ms),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _BankCard  — Widget extraído para cada banco individual
//
// Por qué extraerlo:
//   • Se reutiliza tanto en _BankColumn como en _BankWrap sin duplicar código.
//   • Flutter puede comparar la instancia anterior con la nueva y decidir si
//     reconstruir o no, mejorando el rendimiento.
//   • El código de la pantalla principal queda limpio.
// ─────────────────────────────────────────────────────────────────────────────
class _BankCard extends StatelessWidget {
  const _BankCard({
    required this.bank,
    required this.isSelected,
    required this.connecting,
    required this.onSelect,
    required this.onConnect,
  });

  final dynamic bank;
  final bool isSelected;
  final bool connecting;
  final VoidCallback onSelect;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isActive = isSelected || bank['connected'] ;

    // ── Textos según estado ─────────────────────────────────
    final statusText = bank['connected']
        ? l10n.bankCardStatusConnected
        : isSelected
            ? l10n.bankCardStatusReady
            : l10n.bankCardStatusIdle;

    final btnText = connecting
        ? l10n.bankCardBtnConnecting
        : bank['connected']
            ? l10n.bankCardBtnConnected
            : isSelected
                ? l10n.bankCardBtnConnect
                : l10n.bankCardBtnSelect;

    return NxCard(
      hoverable: !bank['connected'],
      borderColor: isActive ? AppColors.cyan : null,
      glowColor: isActive ? AppColors.cyan : null,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize.min para que el card se ajuste al contenido
        // en el layout de columna (móvil)
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Fila superior: ícono + nombre ─────────────────
          Row(
            children: [
              NxIconBox(
                icon: Icons.account_balance_rounded,
                color: bank['connected'] ? AppColors.emerald : AppColors.cyan,
                size: 36,
                iconSize: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  bank['name'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              // Check si ya está conectado
              if (bank['connected'])
                const Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: AppColors.emerald,
                ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Estado ────────────────────────────────────────
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              color: bank['connected']
                  ? AppColors.emerald
                  : isSelected
                      ? AppColors.cyan
                      : AppColors.textTertiary,
            ),
          ),

          const SizedBox(height: 14),
          const NxDivider(),
          const SizedBox(height: 14),

          // ── Botón acción ──────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 50,
            child: bank['connected']
                ? OutlinedButton(
                    onPressed: (){},
                    child: Text(btnText),
                  )
                : FilledButton(
                    onPressed: connecting
                        ? null
                        : isSelected
                            ? onConnect
                            : onSelect,
                    child: connecting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.bgBase,
                            ),
                          )
                        : Text(btnText),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SecurityNote  — disclamer de seguridad, extraído para no recrearse
// ─────────────────────────────────────────────────────────────────────────────
class _SecurityNote extends StatelessWidget {
  const _SecurityNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_rounded, size: 13, color: AppColors.textTertiary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            context.l10n.connectBankSecurityNote,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LoadingState
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.cyan, strokeWidth: 2),
            SizedBox(height: 16),
            Text(
              'Loading banks…',
              style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ErrorState
// ─────────────────────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 40, color: AppColors.rose),
            const SizedBox(height: 16),
            Text(
              context.l10n.connectBankErrorLoad,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(context.l10n.connectBankRetry),
            ),
          ],
        ),
      ),
    );
  }
}
