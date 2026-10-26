import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/password_check_bloc.dart';
import '../bloc/password_check_event.dart';
import '../bloc/password_check_state.dart';

class PasswordCheckScreen extends StatelessWidget {
  const PasswordCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordCheckBloc(),
      child: const PasswordCheckerView(),
    );
  }
}

class PasswordCheckerView extends StatefulWidget {
  const PasswordCheckerView({super.key});

  @override
  State<PasswordCheckerView> createState() => _PasswordCheckerViewState();
}

class _PasswordCheckerViewState extends State<PasswordCheckerView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, AppLocalizations t) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.translate('pc_copied')),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.teal,
      ),
    );
  }

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
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.teal.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.vpn_key,
                      size: 40,
                      color: AppColors.teal,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    t.translate('pc_title'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.translate('pc_subtitle'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AppColors.textGrey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14171E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2A2E38)),
                    ),
                    child: BlocConsumer<PasswordCheckBloc, PasswordCheckState>(
                      listener: (context, state) {
                        if (_controller.text != state.password && state.password.isNotEmpty) {
                          _controller.text = state.password;
                          _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _controller.text.length),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            TextField(
                              controller: _controller,
                              obscureText: state.isObscured,
                              style: const TextStyle(color: Colors.white),
                              onChanged: (value) {
                                context.read<PasswordCheckBloc>().add(PasswordChangedEvent(value));
                              },
                              decoration: InputDecoration(
                                hintText: t.translate('pc_hint'),
                                hintStyle: const TextStyle(color: Color(0xFF5A6270)),
                                filled: true,
                                fillColor: const Color(0xFF0F1115),
                                suffixIcon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: IconButton(
                                    icon: Icon(
                                      state.isObscured ? Icons.visibility_off : Icons.visibility,
                                      color: AppColors.textGrey,
                                    ),
                                    onPressed: () {
                                      context.read<PasswordCheckBloc>().add(ToggleVisibilityEvent());
                                    },
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: state.isObscured ? const Color(0xFF2A2E38) : AppColors.primaryOrange,
                                    width: state.isObscured ? 1 : 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: state.isObscured ? const Color(0xFF2A2E38) : AppColors.primaryOrange,
                                    width: state.isObscured ? 1 : 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            Row(
                              children: [
                                Expanded(
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: SizedBox(
                                      height: 50,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          context.read<PasswordCheckBloc>().add(GeneratePasswordEvent());
                                        },
                                        icon: const Icon(Icons.autorenew, size: 20, color: Colors.white),
                                        label: Text(
                                          t.translate('pc_generate'),
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Color(0xFF2A2E38)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                MouseRegion(
                                  cursor: state.password.isEmpty ? SystemMouseCursors.basic : SystemMouseCursors.click,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFF2A2E38)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.copy, size: 20, color: Colors.white),
                                      onPressed: state.password.isEmpty ? null : () => _copyToClipboard(state.password, t),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (state.strengthLabel.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Icon(
                                    state.strengthLabel == 'Strong' ? Icons.check_circle_outline : Icons.info_outline,
                                    color: Color(state.colorValue),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.strengthLabel == 'Strong' ? t.translate('pc_strong') : (state.strengthLabel == 'Medium' ? t.translate('pc_medium') : t.translate('pc_weak')),
                                    style: GoogleFonts.inter(
                                      color: Color(state.colorValue),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${state.percentage}%',
                                    style: GoogleFonts.inter(
                                      color: AppColors.textGrey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: state.strengthScore,
                                  minHeight: 8,
                                  backgroundColor: const Color(0xFF2A2E38),
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(state.colorValue)),
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  t.translate('pc_tips'),
                                  style: GoogleFonts.inter(
                                    color: AppColors.textGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildChecklistItem(t.translate('pc_tip1'), state.hasMinLength),
                              _buildChecklistItem(t.translate('pc_tip2'), state.hasUppercase),
                              _buildChecklistItem(t.translate('pc_tip3'), state.hasLowercase),
                              _buildChecklistItem(t.translate('pc_tip4'), state.hasNumber),
                              _buildChecklistItem(t.translate('pc_tip5'), state.hasSpecialChar),
                              _buildChecklistItem(t.translate('pc_tip6'), state.hasRecommendedLength),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14171E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2A2E38)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.translate('pc_pro_tips'),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildProTip(t.translate('pc_pro1')),
                        _buildProTip(t.translate('pc_pro2')),
                        _buildProTip(t.translate('pc_pro3')),
                        _buildProTip(t.translate('pc_pro4')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: isMet ? AppColors.green : AppColors.textGrey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.inter(
              color: isMet ? AppColors.green : AppColors.textGrey,
              fontSize: 14,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0, right: 12.0),
            child: Icon(Icons.circle, size: 6, color: AppColors.teal),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: AppColors.textGrey,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}