import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'alert_event.dart';
import 'alert_state.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  AlertBloc() : super(const AlertState(alerts: [
    ScamAlert(
      titleKey: 'alert1_title',
      messageKey: 'alert1_msg',
      timeKey: 'alert1_time',
      accentColor: Color(0xFFE53935),
      bgColor: Color(0xFF3E1C1C),
    ),
    ScamAlert(
      titleKey: 'alert2_title',
      messageKey: 'alert2_msg',
      timeKey: 'alert2_time',
      accentColor: Color(0xFFFFC107),
      bgColor: Color(0xFF332A10),
    ),
    ScamAlert(
      titleKey: 'alert3_title',
      messageKey: 'alert3_msg',
      timeKey: 'alert3_time',
      accentColor: Color(0xFFE53935),
      bgColor: Color(0xFF3E1C1C),
    ),
    ScamAlert(
      titleKey: 'alert4_title',
      messageKey: 'alert4_msg',
      timeKey: 'alert4_time',
      accentColor: Color(0xFFFFC107),
      bgColor: Color(0xFF332A10),
    ),
  ])) {
    on<NextAlertEvent>((event, emit) {
      int nextIndex = (state.currentIndex + 1) % state.alerts.length;
      emit(state.copyWith(currentIndex: nextIndex));
    });

    on<PreviousAlertEvent>((event, emit) {
      int prevIndex = (state.currentIndex - 1 + state.alerts.length) % state.alerts.length;
      emit(state.copyWith(currentIndex: prevIndex));
    });

    on<CloseAlertEvent>((event, emit) {
      emit(state.copyWith(isVisible: false));
    });
  }
}