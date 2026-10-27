import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/api/api_service.dart';
import 'link_checker_event.dart';
import 'link_checker_state.dart';

class LinkCheckerBloc extends Bloc<LinkCheckerEvent, LinkCheckerState> {
  LinkCheckerBloc() : super(const LinkCheckerState()) {
    on<CheckLinkEvent>(_onCheckLink);
    on<ClearAllChecksEvent>(_onClearAll);
    on<DeleteCheckEvent>(_onDelete);
  }

  Future<void> _onCheckLink(CheckLinkEvent event, Emitter<LinkCheckerState> emit) async {
    if (event.input.trim().isEmpty) return;

    emit(state.copyWith(isLoading: true));

    try {
      final data = await ApiService.checkLink(event.input);

      final bool isSafe = data['safe'] ?? data['isSafe'] ?? true;
      final int score = data['score'] ?? 0;
      final List<String> reasons = (data['reasons'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      final String advice = data['advice'] ?? '';

      final newCheck = RecentCheck(
        input: event.input,
        type: event.input.contains('.') && !event.input.contains(' ') ? 'URL' : 'Message',
        time: 'Just now',
        score: score,
        isSafe: isSafe,
        reasons: reasons,
        advice: advice,
      );

      final updatedChecks = [newCheck, ...state.recentChecks];

      emit(state.copyWith(
        isLoading: false,
        recentChecks: updatedChecks,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onClearAll(ClearAllChecksEvent event, Emitter<LinkCheckerState> emit) {
    emit(state.copyWith(recentChecks: []));
  }

  void _onDelete(DeleteCheckEvent event, Emitter<LinkCheckerState> emit) {
    final updatedChecks = List<RecentCheck>.from(state.recentChecks)..removeAt(event.index);
    emit(state.copyWith(recentChecks: updatedChecks));
  }
}