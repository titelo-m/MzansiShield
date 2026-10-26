import 'package:equatable/equatable.dart';

class RecentCheck extends Equatable {
  final String input;
  final String type;
  final String time;
  final int score;
  final bool isSafe;

  const RecentCheck({
    required this.input,
    required this.type,
    required this.time,
    required this.score,
    required this.isSafe,
  });

  @override
  List<Object> get props => [input, type, time, score, isSafe];
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