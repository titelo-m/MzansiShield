import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/report_scam_bloc.dart';
import '../bloc/report_scam_event.dart';
import '../bloc/report_scam_state.dart';

class ReportScamScreen extends StatelessWidget {
  const ReportScamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportScamBloc(),
      child: const ReportScamView(),
    );
  }
}

class ReportScamView extends StatefulWidget {
  const ReportScamView({super.key});

  @override
  State<ReportScamView> createState() => _ReportScamViewState();
}

class _ReportScamViewState extends State<ReportScamView> {
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  @override
  void dispose() {
    _targetController.dispose();
    _descController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<ReportScamBloc, ReportScamState>(
        listener: (context, state) {
          if (state.isSuccess) {
            _targetController.clear();
            _descController.clear();
            _typeController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.translate('rs_success_title')),
                backgroundColor: AppColors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.errorMessage}'),
                backgroundColor: AppColors.alertRed,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.alertRed.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.flag,
                          size: 40,
                          color: AppColors.alertRed,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        t.translate('rs_title'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        t.translate('rs_subtitle'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.textGrey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      _StatsRow(state: state, t: t),
                      
                      const SizedBox(height: 32),
                      
                      _TabSwitcher(
                        isViewingReports: state.isViewingReports,
                        reportCount: state.reports.length,
                        t: t,
                      ),
                      
                      const SizedBox(height: 24),

                      if (!state.isViewingReports)
                        state.isSuccess 
                          ? _SuccessView(t: t) 
                          : _ReportForm(
                              typeController: _typeController,
                              targetController: _targetController,
                              descController: _descController,
                              isSubmitting: state.isSubmitting,
                              t: t,
                            )
                      else
                        _ReportsList(reports: state.reports, t: t),
                        
                      const SizedBox(height: 40),
                      
                      _HowItWorksBanner(t: t),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final ReportScamState state;
  final AppLocalizations t;

  const _StatsRow({required this.state, required this.t});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final items = [
          _buildStatBox(Icons.folder_outlined, '${state.uniqueScams}', t.translate('rs_unique'), t.translate('rs_db'), AppColors.primaryOrange),
          _buildStatBox(Icons.people_outline, '${state.todayCount}', t.translate('rs_today'), t.translate('rs_live'), AppColors.alertRed),
          _buildStatBox(Icons.shield_outlined, '${state.verifiedCount}', t.translate('rs_verified'), t.translate('rs_confirmed'), AppColors.green),
          _buildStatBox(Icons.group_outlined, '${state.reports.length}', t.translate('rs_reports'), t.translate('rs_total'), AppColors.teal),
          _buildStatBox(Icons.percent, '0%', t.translate('rs_accuracy'), t.translate('rs_rate'), AppColors.primaryOrange),
        ];

        if (isWide) {
          return Row(
            children: items.map((e) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6.0), child: e))).toList(),
          );
        } else {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: items.map((e) => SizedBox(width: (constraints.maxWidth / 2) - 20, child: e)).toList(),
          );
        }
      },
    );
  }

  Widget _buildStatBox(IconData icon, String value, String label, String subLabel, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF14171E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2E38)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
          ),
          Text(
            subLabel,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: AppColors.textGrey, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _TabSwitcher extends StatelessWidget {
  final bool isViewingReports;
  final int reportCount;
  final AppLocalizations t;

  const _TabSwitcher({required this.isViewingReports, required this.reportCount, required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2E38)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              context,
              title: t.translate('rs_tab1'),
              icon: Icons.flag_outlined,
              isActive: !isViewingReports,
              onTap: () => context.read<ReportScamBloc>().add(const SwitchTabEvent(false)),
            ),
          ),
          Expanded(
            child: _buildTab(
              context,
              title: '${t.translate('rs_tab2')} ($reportCount)',
              icon: Icons.visibility_outlined,
              isActive: isViewingReports,
              onTap: () => context.read<ReportScamBloc>().add(const SwitchTabEvent(true)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, {required String title, required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF14171E) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isActive ? Border.all(color: AppColors.primaryOrange, width: 1.5) : null,
          ),
          margin: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isActive ? AppColors.primaryOrange : AppColors.textGrey, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  color: isActive ? Colors.white : AppColors.textGrey,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportForm extends StatelessWidget {
  final TextEditingController typeController;
  final TextEditingController targetController;
  final TextEditingController descController;
  final bool isSubmitting;
  final AppLocalizations t;

  const _ReportForm({
    required this.typeController,
    required this.targetController,
    required this.descController,
    required this.isSubmitting,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF14171E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2E38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(t.translate('rs_target_label'), ''),
          const SizedBox(height: 8),
          _buildTextField(targetController, t.translate('rs_target_hint')),
          
          const SizedBox(height: 24),
          _buildLabel(t.translate('rs_type_label'), ''),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(t.translate('rs_type_hint')),
            dropdownColor: const Color(0xFF1A1D24),
            style: GoogleFonts.inter(color: Colors.white),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey),
            items: const [
              DropdownMenuItem(value: 'Banking/Phishing', child: Text('Banking/Phishing')),
              DropdownMenuItem(value: 'Lottery/Prize Scam', child: Text('Lottery/Prize Scam')),
              DropdownMenuItem(value: 'Job Scam', child: Text('Job Scam')),
              DropdownMenuItem(value: 'SARS/Tax Scam', child: Text('SARS/Tax Scam')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (val) {
              if (val != null) typeController.text = val;
            },
          ),
          
          const SizedBox(height: 24),
          _buildLabel(t.translate('rs_desc_label'), ''),
          const SizedBox(height: 8),
          _buildTextField(descController, t.translate('rs_desc_hint'), maxLines: 4),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D24),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.shield, AppColors.primaryOrange, t.translate('rs_info1_title'), t.translate('rs_info1_desc')),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.check_circle, AppColors.green, t.translate('rs_info2_title'), t.translate('rs_info2_desc')),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.bar_chart, AppColors.teal, t.translate('rs_info3_title'), t.translate('rs_info3_desc')),
              ],
            ),
          ),

          const SizedBox(height: 24),
          MouseRegion(
            cursor: isSubmitting ? SystemMouseCursors.basic : SystemMouseCursors.click,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isSubmitting 
                  ? null 
                  : () {
                      if (targetController.text.isNotEmpty && typeController.text.isNotEmpty) {
                        context.read<ReportScamBloc>().add(SubmitReportEvent(
                          type: typeController.text,
                          target: targetController.text,
                          description: descController.text.isEmpty ? t.translate('rs_no_desc') : descController.text,
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t.translate('rs_target_label'))),
                        );
                      }
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send, size: 20),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            t.translate('rs_submit_btn'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String title, String subTitle) {
    return RichText(
      text: TextSpan(
        text: title,
        style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        children: [
          if (subTitle.isNotEmpty)
            TextSpan(
              text: ' $subTitle',
              style: GoogleFonts.inter(color: AppColors.textGrey, fontWeight: FontWeight.normal, fontSize: 13),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(color: Colors.white),
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: const Color(0xFF5A6270), fontSize: 14),
      filled: true,
      fillColor: const Color(0xFF0F1115),
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2A2E38))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2A2E38))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryOrange)),
    );
  }

  Widget _buildInfoRow(IconData icon, Color color, String boldText, String normalText) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: boldText,
              style: GoogleFonts.inter(color: color, fontWeight: FontWeight.bold, fontSize: 13),
              children: [
                TextSpan(
                  text: ' $normalText',
                  style: GoogleFonts.inter(color: AppColors.textGrey, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  final AppLocalizations t;
  const _SuccessView({required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFF14171E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2E38)),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: AppColors.green, size: 60),
          const SizedBox(height: 16),
          Text(
            t.translate('rs_success_title'),
            style: GoogleFonts.montserrat(color: AppColors.green, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            t.translate('rs_success_desc'),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: AppColors.textGrey, fontSize: 15),
          ),
          const SizedBox(height: 32),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: OutlinedButton(
              onPressed: () => context.read<ReportScamBloc>().add(ResetFormEvent()),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF2A2E38)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(t.translate('rs_success_btn')),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportsList extends StatelessWidget {
  final List<ScamReport> reports;
  final AppLocalizations t;

  const _ReportsList({required this.reports, required this.t});

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: const Color(0xFF14171E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2E38)),
        ),
        child: Center(child: Text(t.translate('rs_empty'), style: GoogleFonts.inter(color: AppColors.textGrey))),
      );
    }

    return Column(
      children: reports.map((report) {
        return _ReportCard(report: report, index: report.id, t: t);
      }).toList(),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final ScamReport report;
  final int index;
  final AppLocalizations t;

  const _ReportCard({required this.report, required this.index, required this.t});

  @override
  Widget build(BuildContext context) {
    final isPending = report.status == 'PENDING';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF14171E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2E38)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        report.type,
                        style: GoogleFonts.inter(color: AppColors.primaryOrange, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2E38),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isPending ? t.translate('rs_pending') : report.status,
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      report.time,
                      style: GoogleFonts.inter(color: AppColors.textGrey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  report.target,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  report.description,
                  style: GoogleFonts.inter(color: AppColors.textGrey, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(t.translate('rs_confidence'), style: GoogleFonts.inter(color: AppColors.textGrey, fontSize: 12)),
                    const Spacer(),
                    Text('${report.confidenceScore}%', style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: report.confidenceScore / 100,
                    minHeight: 6,
                    backgroundColor: const Color(0xFF2A2E38),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.alertRed),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          if (isPending)
            Column(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: OutlinedButton.icon(
                    onPressed: () => context.read<ReportScamBloc>().add(VerifyReportEvent(index)),
                    icon: const Icon(Icons.check, size: 16),
                    label: Text(t.translate('rs_verify_btn')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF2A2E38)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: OutlinedButton.icon(
                    onPressed: () => context.read<ReportScamBloc>().add(MarkFalseReportEvent(index)),
                    icon: const Icon(Icons.close, size: 16),
                    label: Text(t.translate('rs_false_btn')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF2A2E38)),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _HowItWorksBanner extends StatelessWidget {
  final AppLocalizations t;
  const _HowItWorksBanner({required this.t});

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
              const Icon(Icons.shield_outlined, color: AppColors.teal, size: 24),
              const SizedBox(width: 12),
              Text(
                t.translate('rs_how_title'),
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final items = [
                _buildStep(t.translate('rs_how1_title'), t.translate('rs_how1_desc')),
                _buildStep(t.translate('rs_how2_title'), t.translate('rs_how2_desc')),
                _buildStep(t.translate('rs_how3_title'), t.translate('rs_how3_desc')),
              ];
              
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items.map((e) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 16.0), child: e))).toList(),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items.map((e) => Padding(padding: const EdgeInsets.only(bottom: 16.0), child: e)).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 6),
        Text(desc, style: GoogleFonts.inter(color: AppColors.textGrey, fontSize: 13, height: 1.4)),
      ],
    );
  }
}