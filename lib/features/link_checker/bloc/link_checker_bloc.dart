import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/api/api_service.dart';
import 'link_checker_event.dart';
import 'link_checker_state.dart';

class LinkCheckerBloc extends Bloc<LinkCheckerEvent, LinkCheckerState> {
  LinkCheckerBloc() : super(const LinkCheckerState()) {
    on<CheckLinkEvent>(_onCheckLink);
    on<ClearAllChecksEvent>(_onClearAll);
    on<DeleteCheckEvent>(_onDelete);
    on<LoadRecentChecksEvent>(_onLoadRecent);
    add(LoadRecentChecksEvent());
  }

  Future<void> _onCheckLink(CheckLinkEvent event, Emitter<LinkCheckerState> emit) async {
    if (event.input.trim().isEmpty) return;

    emit(state.copyWith(isLoading: true));

    try {
      final data = await ApiService.checkLink(event.input);

      final reasons = (data['reasons'] as List<dynamic>?)
              ?.map((r) => r.toString())
              .toList() ??
          [];

      final newCheck = RecentCheck(
        input: event.input,
        type: event.input.contains('.') && !event.input.contains(' ') ? 'URL' : 'Message',
        time: 'Just now',
        score: (data['score'] as num?)?.toInt() ?? 0,
        isSafe: (data['safe'] ?? data['isSafe'] ?? true) as bool,
        reasons: reasons,
        advice: data['advice'] as String? ?? '',
      );

      emit(state.copyWith(
        isLoading: false,
        recentChecks: [newCheck, ...state.recentChecks],
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLoadRecent(LoadRecentChecksEvent event, Emitter<LinkCheckerState> emit) async {
    try {
      final data = await ApiService.getRecentChecks();
      final checks = data.map(RecentCheck.fromJson).toList();
      emit(state.copyWith(recentChecks: checks));
    } catch (e) {
      // Ignore — local list still shown
    }
  }

  void _onClearAll(ClearAllChecksEvent event, Emitter<LinkCheckerState> emit) {
    emit(state.copyWith(recentChecks: []));
  }

  void _onDelete(DeleteCheckEvent event, Emitter<LinkCheckerState> emit) {
    final updated = List<RecentCheck>.from(state.recentChecks)..removeAt(event.index);
    emit(state.copyWith(recentChecks: updated));
  }
}