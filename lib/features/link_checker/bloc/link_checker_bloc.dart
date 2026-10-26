import 'package:flutter_bloc/flutter_bloc.dart';
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

    await Future.delayed(const Duration(seconds: 2));

    final bool isUrl = event.input.contains('.');
    final bool isSuspicious = event.input.contains('paypal-login') || 
                              event.input.contains('sars') || 
                              event.input.contains('bank') || 
                              !isUrl;

    final newCheck = RecentCheck(
      input: event.input,
      type: isUrl ? 'URL' : 'Message',
      time: 'Just now',
      score: isSuspicious ? 10 : 2,
      isSafe: !isSuspicious,
    );

    final updatedChecks = [newCheck, ...state.recentChecks];

    emit(state.copyWith(
      isLoading: false,
      recentChecks: updatedChecks,
    ));
  }

  void _onClearAll(ClearAllChecksEvent event, Emitter<LinkCheckerState> emit) {
    emit(state.copyWith(recentChecks: []));
  }

  void _onDelete(DeleteCheckEvent event, Emitter<LinkCheckerState> emit) {
    final updatedChecks = List<RecentCheck>.from(state.recentChecks)..removeAt(event.index);
    emit(state.copyWith(recentChecks: updatedChecks));
  }
}