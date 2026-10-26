import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/link_checker_bloc.dart';
import '../bloc/link_checker_event.dart';
import '../bloc/link_checker_state.dart';

class LinkCheckerScreen extends StatelessWidget {
  const LinkCheckerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LinkCheckerBloc(),
      child: const LinkCheckerView(),
    );
  }
}

class LinkCheckerView extends StatefulWidget {
  const LinkCheckerView({super.key});

  @override
  State<LinkCheckerView> createState() => _LinkCheckerViewState();
}

class _LinkCheckerViewState extends State<LinkCheckerView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasText = false;
  int _lastCheckCount = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<LinkCheckerBloc, LinkCheckerState>(
        listener: (context, state) {
          if (state.recentChecks.length > _lastCheckCount) {
            _lastCheckCount = state.recentChecks.length;
            _scrollToBottom();
          }
        },
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF332100),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.search,
                        size: 40,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      t.translate('lc_title'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      t.translate('lc_subtitle'),
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
                      child: Column(
                        children: [
                          TextField(
                            controller: _controller,
                            maxLines: 4,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: t.translate('lc_hint'),
                              hintStyle: const TextStyle(color: Color(0xFF5A6270)),
                              filled: true,
                              fillColor: const Color(0xFF0F1115),
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF2A2E38)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF2A2E38)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.primaryOrange),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<LinkCheckerBloc, LinkCheckerState>(
                            builder: (context, state) {
                              return MouseRegion(
                                cursor: _hasText && !state.isLoading ? SystemMouseCursors.click : SystemMouseCursors.basic,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: (!_hasText || state.isLoading)
                                        ? null
                                        : () {
                                            context.read<LinkCheckerBloc>().add(CheckLinkEvent(_controller.text));
                                            _controller.clear();
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _hasText ? const Color(0xFF996500) : const Color(0xFF2A2E38),
                                      foregroundColor: _hasText ? Colors.white : Colors.white38,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: state.isLoading
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.shield_outlined, size: 20),
                                              const SizedBox(width: 8),
                                              Text(
                                                t.translate('lc_btn'),
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _RecentChecksSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentChecksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<LinkCheckerBloc, LinkCheckerState>(
      builder: (context, state) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        t.translate('lc_recent'),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (state.recentChecks.isNotEmpty)
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: TextButton(
                        onPressed: () => context.read<LinkCheckerBloc>().add(ClearAllChecksEvent()),
                        child: Text(
                          t.translate('lc_clear'),
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (state.recentChecks.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      t.translate('lc_empty'),
                      style: GoogleFonts.inter(color: AppColors.textGrey),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.recentChecks.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final check = state.recentChecks[index];
                    final isSafe = check.isSafe;
                    final color = isSafe ? AppColors.green : const Color(0xFFE53935);

                    return _ExpandableCheckCard(
                      check: check,
                      color: color,
                      index: index,
                      initiallyExpanded: index == 0,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ExpandableCheckCard extends StatefulWidget {
  final RecentCheck check;
  final Color color;
  final int index;
  final bool initiallyExpanded;

  const _ExpandableCheckCard({
    required this.check,
    required this.color,
    required this.index,
    this.initiallyExpanded = false,
  });

  @override
  State<_ExpandableCheckCard> createState() => _ExpandableCheckCardState();
}

class _ExpandableCheckCardState extends State<_ExpandableCheckCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isExpanded ? widget.color.withOpacity(0.3) : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      widget.check.isSafe ? Icons.check_circle_outline : Icons.highlight_off,
                      color: widget.color,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2E38),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  widget.check.type,
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.check.input,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.check.time,
                            style: GoogleFonts.inter(
                              color: AppColors.textGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: widget.color.withOpacity(0.5)),
                      ),
                      child: Text(
                        '${widget.check.score}/10',
                        style: GoogleFonts.inter(
                          color: widget.color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.white54, size: 20),
                        onPressed: () => context.read<LinkCheckerBloc>().add(DeleteCheckEvent(widget.index)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFF2A2E38)),
                  const SizedBox(height: 8),
                  Text(
                    t.translate('lc_why_risky'),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint(t.translate('lc_bullet1')),
                  _buildBulletPoint(t.translate('lc_bullet2')),
                  _buildBulletPoint(t.translate('lc_bullet3')),
                  const SizedBox(height: 16),
                  Text(
                    t.translate('lc_advice'),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.translate('lc_advice_text'),
                    style: GoogleFonts.inter(
                      color: AppColors.textGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0, right: 8.0),
            child: Icon(Icons.circle, size: 6, color: AppColors.primaryOrange),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: AppColors.textGrey,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}