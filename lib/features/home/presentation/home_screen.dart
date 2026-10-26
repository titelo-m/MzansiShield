import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/alert_bloc.dart';
import '../bloc/alert_event.dart';
import '../bloc/alert_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlertBloc(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _AlertBanner(),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: true,
                overscroll: false,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const _HeroSection(),
                    _Footer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  const _AlertBanner();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<AlertBloc, AlertState>(
      builder: (context, state) {
        if (!state.isVisible) return const SizedBox.shrink();
        
        final alert = state.alerts[state.currentIndex];

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: alert.bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: alert.accentColor.withOpacity(0.3), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: alert.accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: alert.accentColor, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              t.translate(alert.titleKey),
                              style: GoogleFonts.inter(
                                color: alert.accentColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.translate(alert.messageKey),
                        style: GoogleFonts.inter(
                          color: alert.accentColor.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.translate(alert.timeKey),
                        style: TextStyle(
                          color: alert.accentColor.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: IconButton(
                        icon: Icon(Icons.chevron_left, color: alert.accentColor, size: 20),
                        onPressed: () => context.read<AlertBloc>().add(PreviousAlertEvent()),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${state.currentIndex + 1}/${state.alerts.length}',
                        style: TextStyle(color: alert.accentColor, fontSize: 13),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: IconButton(
                        icon: Icon(Icons.chevron_right, color: alert.accentColor, size: 20),
                        onPressed: () => context.read<AlertBloc>().add(NextAlertEvent()),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: IconButton(
                        icon: Icon(Icons.close, color: alert.accentColor, size: 20),
                        onPressed: () => context.read<AlertBloc>().add(CloseAlertEvent()),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryOrange.withOpacity(0.15),
                  Colors.transparent,
                ],
                radius: 0.5,
              ),
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 170,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            t.translate('stay_safe'),
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: AppColors.primaryOrange,
              fontSize: 52,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            t.translate('hero_subtitle'),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.textGrey,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _FeaturePill(text: t.translate('ai_threat')),
              _FeaturePill(text: t.translate('sa_database')),
              _FeaturePill(text: t.translate('multilingual')),
            ],
          ),
          const SizedBox(height: 24),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SizedBox(
              width: 450,
              height: 64,
              child: ElevatedButton(
                onPressed: () => context.go('/link-checker'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        t.translate('check_link_btn'),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 24),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final String text;

  const _FeaturePill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF2A2E38)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: AppColors.green, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF232730), width: 1),
        ),
      ),
      child: Text(
        '© 2026 MzansiShield. Protecting South Africans online.',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          color: AppColors.textGrey,
          fontSize: 14,
        ),
      ),
    );
  }
}