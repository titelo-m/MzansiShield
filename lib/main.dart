import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization/app_translations.dart';
import 'core/localization/language_bloc.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MzansiShieldApp());
}

class MzansiShieldApp extends StatelessWidget {
  const MzansiShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageBloc(),
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'MzansiShield',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            routerConfig: appRouter,
            locale: state.locale,
            supportedLocales: AppTranslations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              SafeMaterialLocalizationsDelegate(), // Our new safe delegate
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}