import 'package:equatable/equatable.dart';

class ScamReport extends Equatable {
  final String type;
  final String target;
  final String description;
  final String time;
  final int confidenceScore;
  final String status;

  const ScamReport({
    required this.type,
    required this.target,
    required this.description,
    required this.time,
    required this.confidenceScore,
    this.status = 'Pending',
  });

  ScamReport copyWith({String? status}) {
    return ScamReport(
      type: type,
      target: target,
      description: description,
      time: time,
      confidenceScore: confidenceScore,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [type, target, description, time, confidenceScore, status];
}

class ReportScamState extends Equatable {
  final bool isViewingReports;
  final bool isSubmitting;
  final bool isSuccess;
  final List<ScamReport> reports;
  final int uniqueScams;
  final int todayCount;
  final int verifiedCount;

  const ReportScamState({
    this.isViewingReports = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.reports = const [],
    this.uniqueScams = 0,
    this.todayCount = 0,
    this.verifiedCount = 0,
  });

  ReportScamState copyWith({
    bool? isViewingReports,
    bool? isSubmitting,
    bool? isSuccess,
    List<ScamReport>? reports,
    int? uniqueScams,
    int? todayCount,
    int? verifiedCount,
  }) {
    return ReportScamState(
      isViewingReports: isViewingReports ?? this.isViewingReports,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      reports: reports ?? this.reports,
      uniqueScams: uniqueScams ?? this.uniqueScams,
      todayCount: todayCount ?? this.todayCount,
      verifiedCount: verifiedCount ?? this.verifiedCount,
    );
  }

  @override
  List<Object> get props => [
        isViewingReports, isSubmitting, isSuccess, reports, 
        uniqueScams, todayCount, verifiedCount
      ];
}