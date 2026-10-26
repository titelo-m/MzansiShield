import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/theme/app_theme.dart';

class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.lightbulb_outline,
                      size: 40,
                      color: AppColors.green,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    t.translate('st_title'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.translate('st_subtitle'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AppColors.textGrey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  _EmergencyContactsBanner(t: t),
                  
                  const SizedBox(height: 32),
                  
                  _TipsGrid(t: t),
                  
                  const SizedBox(height: 40),
                  
                  _StatsFooter(t: t),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmergencyContactsBanner extends StatelessWidget {
  final AppLocalizations t;
  const _EmergencyContactsBanner({required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1F1C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.teal.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.teal, size: 24),
              const SizedBox(width: 12),
              Text(
                t.translate('st_emergency'),
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final spacing = 16.0;
              final itemWidth = isWide ? (constraints.maxWidth - (spacing * 2)) / 3 : constraints.maxWidth;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  _ContactCard(
                    width: itemWidth,
                    title: t.translate('st_saps'),
                    number: '10111',
                  ),
                  _ContactCard(
                    width: itemWidth,
                    title: t.translate('st_hotline'),
                    number: '0800 701 701',
                  ),
                  _ContactCard(
                    width: itemWidth,
                    title: t.translate('st_sabric'),
                    number: '0800 020 080',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            t.translate('st_save'),
            style: GoogleFonts.inter(
              color: AppColors.textGrey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final double width;
  final String title;
  final String number;

  const _ContactCard({
    required this.width,
    required this.title,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14171E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2E38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            number,
            style: GoogleFonts.inter(
              color: AppColors.teal,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TipsGrid extends StatelessWidget {
  final AppLocalizations t;
  const _TipsGrid({required this.t});

  @override
  Widget build(BuildContext context) {
    final tips = [
      _TipItem(icon: Icons.lock_outline, title: t.translate('st_tip1_title'), priority: t.translate('st_high'), priorityColor: const Color(0xFFE53935), description: t.translate('st_tip1_desc')),
      _TipItem(icon: Icons.account_balance_outlined, title: t.translate('st_tip2_title'), priority: t.translate('st_high'), priorityColor: const Color(0xFFE53935), description: t.translate('st_tip2_desc')),
      _TipItem(icon: Icons.shield_outlined, title: t.translate('st_tip3_title'), priority: t.translate('st_med'), priorityColor: const Color(0xFFFF9800), description: t.translate('st_tip3_desc')),
      _TipItem(icon: Icons.card_giftcard, title: t.translate('st_tip4_title'), priority: t.translate('st_med'), priorityColor: const Color(0xFFFF9800), description: t.translate('st_tip4_desc')),
      _TipItem(icon: Icons.phone_in_talk_outlined, title: t.translate('st_tip5_title'), priority: t.translate('st_gen'), priorityColor: const Color(0xFF4CAF50), description: t.translate('st_tip5_desc')),
      _TipItem(icon: Icons.vpn_key_outlined, title: t.translate('st_tip6_title'), priority: t.translate('st_gen'), priorityColor: const Color(0xFF4CAF50), description: t.translate('st_tip6_desc')),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = constraints.maxWidth > 1000 ? 3 : (constraints.maxWidth > 650 ? 2 : 1);
        double spacing = 24.0;
        double itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: tips.map((tip) {
            return _TipCard(width: itemWidth, tip: tip);
          }).toList(),
        );
      },
    );
  }
}

class _TipItem {
  final IconData icon;
  final String title;
  final String priority;
  final Color priorityColor;
  final String description;

  _TipItem({
    required this.icon,
    required this.title,
    required this.priority,
    required this.priorityColor,
    required this.description,
  });
}

class _TipCard extends StatelessWidget {
  final double width;
  final _TipItem tip;

  const _TipCard({required this.width, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF14171E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2E38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tip.priorityColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(tip.icon, color: tip.priorityColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  tip.title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tip.priorityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: tip.priorityColor.withOpacity(0.3)),
            ),
            child: Text(
              tip.priority,
              style: GoogleFonts.inter(
                color: tip.priorityColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            tip.description,
            style: GoogleFonts.inter(
              color: AppColors.textGrey,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsFooter extends StatelessWidget {
  final AppLocalizations t;
  const _StatsFooter({required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF14171E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          
          final items = [
            _buildStat('94%', t.translate('st_stat1'), AppColors.primaryOrange),
            _buildStat('50K+', t.translate('st_stat2'), AppColors.green),
            _buildStat('11', t.translate('st_stat3'), AppColors.teal),
            _buildStat('24/7', t.translate('st_stat4'), AppColors.primaryOrange),
          ];

          if (isWide) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items,
            );
          } else {
            return Wrap(
              spacing: 32,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: items,
            );
          }
        },
      ),
    );
  }

  Widget _buildStat(String value, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.montserrat(
            color: color,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textGrey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}