import 'package:equatable/equatable.dart';

class ScamReport extends Equatable {
  final int id;
  final String type;
  final String target;
  final String description;
  final String time;
  final int confidenceScore;
  final String status;

  const ScamReport({
    required this.id,
    required this.type,
    required this.target,
    required this.description,
    required this.time,
    required this.confidenceScore,
    this.status = 'PENDING',
  });

  factory ScamReport.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'] != null 
        ? DateTime.parse(json['createdAt'] as String) 
        : DateTime.now();
    final diff = DateTime.now().difference(createdAt);

    String time;
    if (diff.inMinutes < 1) {
      time = 'Just now';
    } else if (diff.inMinutes < 60) {
      time = '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      time = '${diff.inHours} hr ago';
    } else {
      time = '${diff.inDays} days ago';
    }

    return ScamReport(
      id: json['id'] as int,
      type: json['type'] as String? ?? 'Unknown',
      target: json['target'] as String? ?? '',
      description: json['description'] as String? ?? '',
      time: time,
      confidenceScore: json['confidenceScore'] as int? ?? 10,
      status: json['status'] as String? ?? 'PENDING',
    );
  }

  ScamReport copyWith({String? status}) {
    return ScamReport(
      id: id,
      type: type,
      target: target,
      description: description,
      time: time,
      confidenceScore: confidenceScore,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [id, type, target, description, time, confidenceScore, status];
}

class ReportScamState extends Equatable {
  final bool isViewingReports;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final List<ScamReport> reports;
  final int uniqueScams;
  final int todayCount;
  final int verifiedCount;

  const ReportScamState({
    this.isViewingReports = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.reports = const [],
    this.uniqueScams = 0,
    this.todayCount = 0,
    this.verifiedCount = 0,
  });

  ReportScamState copyWith({
    bool? isViewingReports,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    List<ScamReport>? reports,
    int? uniqueScams,
    int? todayCount,
    int? verifiedCount,
  }) {
    return ReportScamState(
      isViewingReports: isViewingReports ?? this.isViewingReports,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      reports: reports ?? this.reports,
      uniqueScams: uniqueScams ?? this.uniqueScams,
      todayCount: todayCount ?? this.todayCount,
      verifiedCount: verifiedCount ?? this.verifiedCount,
    );
  }

  @override
  List<Object?> get props => [
        isViewingReports,
        isSubmitting,
        isSuccess,
        errorMessage,
        reports,
        uniqueScams,
        todayCount,
        verifiedCount,
      ];
}