import 'package:equatable/equatable.dart';

abstract class ReportScamEvent extends Equatable {
  const ReportScamEvent();

  @override
  List<Object> get props => [];
}

class SwitchTabEvent extends ReportScamEvent {
  final bool isViewingReports;

  const SwitchTabEvent(this.isViewingReports);

  @override
  List<Object> get props => [isViewingReports];
}

class SubmitReportEvent extends ReportScamEvent {
  final String type;
  final String target;
  final String description;

  const SubmitReportEvent({
    required this.type,
    required this.target,
    required this.description,
  });

  @override
  List<Object> get props => [type, target, description];
}

class ResetFormEvent extends ReportScamEvent {}

class VerifyReportEvent extends ReportScamEvent {
  final int index;

  const VerifyReportEvent(this.index);

  @override
  List<Object> get props => [index];
}

class MarkFalseReportEvent extends ReportScamEvent {
  final int index;

  const MarkFalseReportEvent(this.index);

  @override
  List<Object> get props => [index];
}