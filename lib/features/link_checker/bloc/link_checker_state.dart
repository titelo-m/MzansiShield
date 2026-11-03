import 'package:equatable/equatable.dart';

class RecentCheck extends Equatable {
  final int? id;
  final String input;
  final String type;
  final String time;
  final int score;
  final bool isSafe;
  final List<String> reasons;
  final String advice;

  const RecentCheck({
    this.id,
    required this.input,
    required this.type,
    required this.time,
    required this.score,
    required this.isSafe,
    this.reasons = const [],
    this.advice = '',
  });

  factory RecentCheck.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now();
    final diff = DateTime.now().difference(createdAt);
    final time = diff.inMinutes < 1
        ? 'Just now'
        : diff.inMinutes < 60
            ? '${diff.inMinutes} min ago'
            : diff.inHours < 24
                ? '${diff.inHours} hr ago'
                : '${diff.inDays} days ago';

    final reasons = (json['reasons'] as List<dynamic>?)
            ?.where((r) => r != null && r.toString().isNotEmpty)
            .map((r) => r.toString())
            .toList() ??
        [];

    return RecentCheck(
      id: json['id'] as int?,
      input: json['input'] as String? ?? '',
      type: json['type'] as String? ?? 'Message',
      time: time,
      score: json['score'] as int? ?? 0,
      isSafe: json['isSafe'] as bool? ?? true,
      reasons: reasons,
      advice: json['advice'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, input, type, time, score, isSafe, reasons, advice];
}

class LinkCheckerState extends Equatable {
  final bool isLoading;
  final List<RecentCheck> recentChecks;

  const LinkCheckerState({
    this.isLoading = false,
    this.recentChecks = const [],
  });

  LinkCheckerState copyWith({
    bool? isLoading,
    List<RecentCheck>? recentChecks,
  }) {
    return LinkCheckerState(
      isLoading: isLoading ?? this.isLoading,
      recentChecks: recentChecks ?? this.recentChecks,
    );
  }

  @override
  List<Object> get props => [isLoading, recentChecks];
}