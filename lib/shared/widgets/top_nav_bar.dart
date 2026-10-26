import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_translations.dart';
import '../../core/localization/language_bloc.dart';
import '../../core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class TopNavBar extends StatelessWidget {
  final String currentPath;

  const TopNavBar({super.key, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: Color(0xFF232730), width: 1),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // INCREASED BREAKPOINT: 
          // If the screen is smaller than 1100px, we use the mobile menu.
          // This ensures long translated words don't break the layout.
          final isMobile = constraints.maxWidth < 1100;

          return Stack(
            children: [
              // Center Layer: Desktop Navigation Links
              if (!isMobile)
                Positioned.fill(
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _NavItem(title: t.translate('home'), path: '/', currentPath: currentPath),
                          _NavItem(title: t.translate('link_checker'), path: '/link-checker', currentPath: currentPath),
                          _NavItem(title: t.translate('password_check'), path: '/password-check', currentPath: currentPath),
                          _NavItem(title: t.translate('safety_tips'), path: '/safety-tips', currentPath: currentPath),
                          _NavItem(title: t.translate('report_scam'), path: '/report-scam', currentPath: currentPath),
                        ],
                      ),
                    ),
                  ),
                ),

              // Left Layer: Logo
              Align(
                alignment: Alignment.centerLeft,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: () => context.go('/'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shield_outlined, color: AppColors.primaryOrange, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'MzansiShield',
                          style: GoogleFonts.montserrat(
                            color: AppColors.primaryOrange,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
                
              // Right Layer: Language Selector & Mobile Menu
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LanguageSelector(currentLocale: currentLocale),
                    if (isMobile) ...[
                      const SizedBox(width: 16),
                      _MobileMenuSelector(currentPath: currentPath, t: t),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final String path;
  final String currentPath;

  const _NavItem({
    required this.title,
    required this.path,
    required this.currentPath,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.currentPath == widget.path;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.go(widget.path),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isActive 
                  ? const Color(0xFF332100) 
                  : (_isHovered ? const Color(0xFF2A2A2A) : Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.title,
              style: GoogleFonts.inter(
                color: isActive 
                    ? AppColors.primaryOrange 
                    : (_isHovered ? Colors.white : AppColors.textGrey),
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatefulWidget {
  final String currentLocale;

  const _LanguageSelector({required this.currentLocale});

  @override
  State<_LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<_LanguageSelector> {
  bool _isHovered = false;

  final Map<String, String> languages = {
    'en': 'English',
    'af': 'Afrikaans',
    'zu': 'isiZulu',
    'xh': 'isiXhosa',
    'nso': 'Sepedi',
    'st': 'Sesotho',
    'tn': 'Setswana',
    'ss': 'siSwati',
    've': 'Tshivenda',
    'ts': 'Xitsonga',
    'nr': 'isiNdebele',
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: '',
      offset: const Offset(0, 50),
      color: const Color(0xFF1A1D24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF2A2E38)),
      ),
      onSelected: (String code) {
        context.read<LanguageBloc>().changeLanguage(code);
      },
      itemBuilder: (BuildContext context) {
        return languages.entries.map((entry) {
          final isSelected = entry.key == widget.currentLocale;
          return PopupMenuItem<String>(
            value: entry.key,
            height: 40,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.green.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  entry.value,
                  style: GoogleFonts.inter(
                    color: isSelected ? AppColors.green : Colors.white,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList();
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.green.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.language, color: _isHovered ? AppColors.green : Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                languages[widget.currentLocale] ?? 'English',
                style: GoogleFonts.inter(
                  color: _isHovered ? AppColors.green : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileMenuSelector extends StatelessWidget {
  final String currentPath;
  final AppLocalizations t;

  const _MobileMenuSelector({required this.currentPath, required this.t});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: '',
      icon: const Icon(Icons.menu, color: Colors.white),
      offset: const Offset(0, 50),
      color: const Color(0xFF1A1D24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF2A2E38)),
      ),
      onSelected: (String path) {
        context.go(path);
      },
      itemBuilder: (BuildContext context) {
        final paths = ['/', '/link-checker', '/password-check', '/safety-tips', '/report-scam'];
        final titles = [
          t.translate('home'),
          t.translate('link_checker'),
          t.translate('password_check'),
          t.translate('safety_tips'),
          t.translate('report_scam'),
        ];

        return List.generate(paths.length, (index) {
          final isActive = currentPath == paths[index];
          return PopupMenuItem<String>(
            value: paths[index],
            height: 45,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.green.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  titles[index],
                  style: GoogleFonts.inter(
                    color: isActive ? AppColors.green : Colors.white,
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}