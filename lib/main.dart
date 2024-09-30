import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/home_screed.dart';
import 'package:flutter_application_2/screens/login_screen.dart';
import 'package:flutter_application_2/screens/movies_screen.dart';
import 'package:flutter_application_2/screens/onboarding_screen.dart';
import 'package:flutter_application_2/screens/personajes_screen.dart';
import 'package:flutter_application_2/settings/global_values.dart';
import 'package:flutter_application_2/settings/theme_settings.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      //valueListenable: GlobalValues.banThemeDark,
      valueListenable: GlobalValues.selectedTheme,
      builder: (context, _, __) {
        return ValueListenableBuilder(
          valueListenable: GlobalValues.selectedFontFamily,
          builder: (context, fontFamily, _) {
            return MaterialApp(
              title: 'Material App',
              theme: _getCurrentTheme(context),
              /*theme: GlobalValues.banThemeDark.value
                  ? ThemeSettings.darkTheme(context, fontFamily)
                  : ThemeSettings.lightTheme(context, fontFamily),*/
              debugShowCheckedModeBanner: false,
              home: const LoginScreen(),
              routes: {
                "/home": (context) => const HomeScreen(),
                "/personajes": (context) => const PersonajesScreen(),
                "/movies": (context) => const MoviesScreen(),
                "/onboarding": (context) => const OnboardingScreen(),
              },
            );
          },
        );
      },
    );
  }

  ThemeData _getCurrentTheme(BuildContext context) {
    String fontFamily = GlobalValues.selectedFontFamily.value;
    String selectedTheme = GlobalValues.selectedTheme.value;

    if (selectedTheme == 'Light') {
      return ThemeSettings.lightTheme(context, fontFamily);
    } else if (selectedTheme == 'Dark') {
      return ThemeSettings.darkTheme(context, fontFamily);
    } else {  // Si es personalizado
      return ThemeSettings.personalizedTheme(context, fontFamily);
    }
  }

}
