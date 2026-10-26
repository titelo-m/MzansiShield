import 'package:equatable/equatable.dart';

abstract class LinkCheckerEvent extends Equatable {
  const LinkCheckerEvent();

  @override
  List<Object> get props => [];
}

class CheckLinkEvent extends LinkCheckerEvent {
  final String input;

  const CheckLinkEvent(this.input);

  @override
  List<Object> get props => [input];
}

class ClearAllChecksEvent extends LinkCheckerEvent {}

class DeleteCheckEvent extends LinkCheckerEvent {
  final int index;

  const DeleteCheckEvent(this.index);

  @override
  List<Object> get props => [index];
}