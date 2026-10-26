import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'password_check_event.dart';
import 'password_check_state.dart';

class PasswordCheckBloc extends Bloc<PasswordCheckEvent, PasswordCheckState> {
  PasswordCheckBloc() : super(const PasswordCheckState()) {
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<ToggleVisibilityEvent>(_onToggleVisibility);
    on<GeneratePasswordEvent>(_onGeneratePassword);
  }

  void _onPasswordChanged(PasswordChangedEvent event, Emitter<PasswordCheckState> emit) {
    final password = event.password;
    if (password.isEmpty) {
      emit(const PasswordCheckState());
      return;
    }

    final hasMinLength = password.length >= 8;
    final hasRecommendedLength = password.length >= 12;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int scorePoints = 0;
    if (hasMinLength) scorePoints++;
    if (hasUppercase) scorePoints++;
    if (hasLowercase) scorePoints++;
    if (hasNumber) scorePoints++;
    if (hasSpecialChar) scorePoints++;
    if (hasRecommendedLength) scorePoints++;

    double score = scorePoints / 6.0;
    
    String label;
    int color;

    if (score < 0.4) {
      label = 'Weak';
      color = 0xFFE53935;
    } else if (score < 0.7) {
      label = 'Medium';
      color = 0xFFFF9800;
    } else {
      label = 'Strong';
      color = 0xFF4CAF50;
    }

    emit(state.copyWith(
      password: password,
      strengthScore: score,
      strengthLabel: label,
      colorValue: color,
      percentage: (score * 100).toInt(),
      hasMinLength: hasMinLength,
      hasUppercase: hasUppercase,
      hasLowercase: hasLowercase,
      hasNumber: hasNumber,
      hasSpecialChar: hasSpecialChar,
      hasRecommendedLength: hasRecommendedLength,
    ));
  }

  void _onToggleVisibility(ToggleVisibilityEvent event, Emitter<PasswordCheckState> emit) {
    emit(state.copyWith(isObscured: !state.isObscured));
  }

  void _onGeneratePassword(GeneratePasswordEvent event, Emitter<PasswordCheckState> emit) {
    const String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lower = 'abcdefghijklmnopqrstuvwxyz';
    const String numbers = '0123456789';
    const String symbols = '!@#\$%^&*()_+';
    const String all = upper + lower + numbers + symbols;

    final Random random = Random();
    String generated = '';

    generated += upper[random.nextInt(upper.length)];
    generated += lower[random.nextInt(lower.length)];
    generated += numbers[random.nextInt(numbers.length)];
    generated += symbols[random.nextInt(symbols.length)];

    for (int i = 0; i < 12; i++) {
      generated += all[random.nextInt(all.length)];
    }

    final List<String> shuffled = generated.split('')..shuffle();
    final result = shuffled.join();

    add(PasswordChangedEvent(result));
    emit(state.copyWith(isObscured: false));
  }
}