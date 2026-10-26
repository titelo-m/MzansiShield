import 'package:equatable/equatable.dart';

abstract class PasswordCheckEvent extends Equatable {
  const PasswordCheckEvent();

  @override
  List<Object> get props => [];
}

class PasswordChangedEvent extends PasswordCheckEvent {
  final String password;

  const PasswordChangedEvent(this.password);

  @override
  List<Object> get props => [password];
}

class ToggleVisibilityEvent extends PasswordCheckEvent {}

class GeneratePasswordEvent extends PasswordCheckEvent {}