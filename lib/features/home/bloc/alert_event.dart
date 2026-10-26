import 'package:equatable/equatable.dart';

abstract class AlertEvent extends Equatable {
  const AlertEvent();

  @override
  List<Object> get props => [];
}

class NextAlertEvent extends AlertEvent {}

class PreviousAlertEvent extends AlertEvent {}

class CloseAlertEvent extends AlertEvent {}