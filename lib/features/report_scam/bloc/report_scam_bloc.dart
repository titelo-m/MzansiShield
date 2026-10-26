import 'package:flutter_bloc/flutter_bloc.dart';
import 'report_scam_event.dart';
import 'report_scam_state.dart';

class ReportScamBloc extends Bloc<ReportScamEvent, ReportScamState> {
  ReportScamBloc() : super(const ReportScamState()) {
    on<SwitchTabEvent>(_onSwitchTab);
    on<SubmitReportEvent>(_onSubmitReport);
    on<ResetFormEvent>(_onResetForm);
    on<VerifyReportEvent>(_onVerify);
    on<MarkFalseReportEvent>(_onMarkFalse);
  }

  void _onSwitchTab(SwitchTabEvent event, Emitter<ReportScamState> emit) {
    emit(state.copyWith(isViewingReports: event.isViewingReports, isSuccess: false));
  }

  Future<void> _onSubmitReport(SubmitReportEvent event, Emitter<ReportScamState> emit) async {
    emit(state.copyWith(isSubmitting: true));

    await Future.delayed(const Duration(seconds: 2));

    final newReport = ScamReport(
      type: event.type,
      target: event.target,
      description: event.description,
      time: '0 min ago',
      confidenceScore: 10,
    );

    emit(state.copyWith(
      isSubmitting: false,
      isSuccess: true,
      reports: [newReport, ...state.reports],
      uniqueScams: state.uniqueScams + 1,
      todayCount: state.todayCount + 1,
    ));
  }

  void _onResetForm(ResetFormEvent event, Emitter<ReportScamState> emit) {
    emit(state.copyWith(isSuccess: false));
  }

  void _onVerify(VerifyReportEvent event, Emitter<ReportScamState> emit) {
    final updated = List<ScamReport>.from(state.reports);
    updated[event.index] = updated[event.index].copyWith(status: 'Verified');
    emit(state.copyWith(reports: updated, verifiedCount: state.verifiedCount + 1));
  }

  void _onMarkFalse(MarkFalseReportEvent event, Emitter<ReportScamState> emit) {
    final updated = List<ScamReport>.from(state.reports);
    updated[event.index] = updated[event.index].copyWith(status: 'False');
    emit(state.copyWith(reports: updated));
  }
}