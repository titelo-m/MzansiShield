import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ScamAlert extends Equatable {
  final String titleKey;
  final String messageKey;
  final String timeKey;
  final Color accentColor;
  final Color bgColor;

  const ScamAlert({
    required this.titleKey,
    required this.messageKey,
    required this.timeKey,
    required this.accentColor,
    required this.bgColor,
  });

  @override
  List<Object> get props => [titleKey, messageKey, timeKey];
}

class AlertState extends Equatable {
  final List<ScamAlert> alerts;
  final int currentIndex;
  final bool isVisible;

  const AlertState({
    required this.alerts,
    this.currentIndex = 0,
    this.isVisible = true,
  });

  AlertState copyWith({
    List<ScamAlert>? alerts,
    int? currentIndex,
    bool? isVisible,
  }) {
    return AlertState(
      alerts: alerts ?? this.alerts,
      currentIndex: currentIndex ?? this.currentIndex,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  List<Object> get props => [alerts, currentIndex, isVisible];
}