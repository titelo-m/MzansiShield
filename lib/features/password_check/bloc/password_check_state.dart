import 'package:equatable/equatable.dart';

class PasswordCheckState extends Equatable {
  final String password;
  final bool isObscured;
  final double strengthScore;
  final String strengthLabel;
  final int colorValue;
  final int percentage;
  
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSpecialChar;
  final bool hasRecommendedLength;

  const PasswordCheckState({
    this.password = '',
    this.isObscured = true,
    this.strengthScore = 0.0,
    this.strengthLabel = '',
    this.colorValue = 0xFF2A2E38,
    this.percentage = 0,
    this.hasMinLength = false,
    this.hasUppercase = false,
    this.hasLowercase = false,
    this.hasNumber = false,
    this.hasSpecialChar = false,
    this.hasRecommendedLength = false,
  });

  PasswordCheckState copyWith({
    String? password,
    bool? isObscured,
    double? strengthScore,
    String? strengthLabel,
    int? colorValue,
    int? percentage,
    bool? hasMinLength,
    bool? hasUppercase,
    bool? hasLowercase,
    bool? hasNumber,
    bool? hasSpecialChar,
    bool? hasRecommendedLength,
  }) {
    return PasswordCheckState(
      password: password ?? this.password,
      isObscured: isObscured ?? this.isObscured,
      strengthScore: strengthScore ?? this.strengthScore,
      strengthLabel: strengthLabel ?? this.strengthLabel,
      colorValue: colorValue ?? this.colorValue,
      percentage: percentage ?? this.percentage,
      hasMinLength: hasMinLength ?? this.hasMinLength,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasLowercase: hasLowercase ?? this.hasLowercase,
      hasNumber: hasNumber ?? this.hasNumber,
      hasSpecialChar: hasSpecialChar ?? this.hasSpecialChar,
      hasRecommendedLength: hasRecommendedLength ?? this.hasRecommendedLength,
    );
  }

  @override
  List<Object> get props => [
        password, isObscured, strengthScore, strengthLabel, colorValue,
        percentage, hasMinLength, hasUppercase, hasLowercase, hasNumber,
        hasSpecialChar, hasRecommendedLength
      ];
}