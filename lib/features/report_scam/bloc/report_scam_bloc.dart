import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/api/api_service.dart';
import 'report_scam_event.dart';
import 'report_scam_state.dart';

class ReportScamBloc extends Bloc<ReportScamEvent, ReportScamState> {
  ReportScamBloc() : super(const ReportScamState()) {
    on<SwitchTabEvent>(_onSwitchTab);
    on<SubmitReportEvent>(_onSubmitReport);
    on<ResetFormEvent>(_onResetForm);
    on<LoadReportsEvent>(_onLoadReports);
    on<VerifyReportEvent>(_onVerify);
    on<MarkFalseReportEvent>(_onMarkFalse);
  }

  void _onSwitchTab(SwitchTabEvent event, Emitter<ReportScamState> emit) {
    emit(state.copyWith(isViewingReports: event.isViewingReports, isSuccess: false));
    if (event.isViewingReports) {
      add(LoadReportsEvent());
    }
  }

  Future<void> _onSubmitReport(SubmitReportEvent event, Emitter<ReportScamState> emit) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final result = await ApiService.submitReport(
        target: event.target,
        type: event.type,
        description: event.description,
      );

      final newReport = ScamReport.fromJson(result);

      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        reports: [newReport, ...state.reports],
        uniqueScams: state.uniqueScams + 1,
        todayCount: state.todayCount + 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetForm(ResetFormEvent event, Emitter<ReportScamState> emit) {
    emit(state.copyWith(isSuccess: false, errorMessage: null));
  }

  Future<void> _onLoadReports(LoadReportsEvent event, Emitter<ReportScamState> emit) async {
    try {
      final data = await ApiService.getAllReports();
      final reports = data.map(ScamReport.fromJson).toList();
      final stats = await ApiService.getStats();

      emit(state.copyWith(
        reports: reports,
        uniqueScams: reports.length,
        verifiedCount: stats['verifiedReports'] ?? 0,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onVerify(VerifyReportEvent event, Emitter<ReportScamState> emit) async {
    try {
      final result = await ApiService.verifyReport(event.id);
      final updated = ScamReport.fromJson(result);

      final reports = state.reports
          .map((r) => r.id == event.id ? updated : r)
          .toList();

      emit(state.copyWith(
        reports: reports,
        verifiedCount: state.verifiedCount + 1,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onMarkFalse(MarkFalseReportEvent event, Emitter<ReportScamState> emit) async {
    try {
      final result = await ApiService.markFalseReport(event.id);
      final updated = ScamReport.fromJson(result);

      final reports = state.reports
          .map((r) => r.id == event.id ? updated : r)
          .toList();

      emit(state.copyWith(reports: reports));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}