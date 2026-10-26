import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState(this.locale);

  @override
  List<Object> get props => [locale];
}

class LanguageBloc extends Cubit<LanguageState> {
  LanguageBloc() : super(const LanguageState(Locale('en')));

  void changeLanguage(String languageCode) {
    emit(LanguageState(Locale(languageCode)));
  }
}