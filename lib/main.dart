import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/firebase_options.dart';
import 'package:flutter_application_2/provider/test_provider.dart';
import 'package:flutter_application_2/screens/detail_popular_screen.dart';
import 'package:flutter_application_2/screens/home_screed.dart';
import 'package:flutter_application_2/screens/login_screen.dart';
import 'package:flutter_application_2/screens/movies_screen.dart';
import 'package:flutter_application_2/screens/onboarding_screen.dart';
import 'package:flutter_application_2/screens/personajes_screen.dart';
import 'package:flutter_application_2/screens/popular_screen.dart';
import 'package:flutter_application_2/screens/registro_screen.dart';
import 'package:flutter_application_2/settings/global_values.dart';
import 'package:flutter_application_2/settings/theme_settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Cargamos las preferencias guardadas
  final prefs = await SharedPreferences.getInstance();
  final selectedTheme = prefs.getString('selectedTheme') ?? 'Light';
  final selectedFont = prefs.getString('selectedFontFamily') ?? 'Roboto';

  // Actualizamos los GlobalValues con los valores almacenados
  GlobalValues.selectedTheme.value = selectedTheme;
  GlobalValues.selectedFontFamily.value = selectedFont;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalValues.selectedTheme,
      builder: (context, _, __) {
        return ValueListenableBuilder(
          valueListenable: GlobalValues.selectedFontFamily,
          builder: (context, fontFamily, _) {
            return ChangeNotifierProvider(
              create: (context) => TestProvider(),
              child: MaterialApp(
                title: 'Material App',
                theme: _getCurrentTheme(context),
                debugShowCheckedModeBanner: false,
                home: const LoginScreen(), // Cambia a la pantalla deseada
                routes: {
                  "/home": (context) => const HomeScreen(),
                  "/personajes": (context) => const PersonajesScreen(),
                  "/movies": (context) => const MoviesScreen(),
                  "/onboarding": (context) => const OnboardingScreen(),
                  "/login": (context) => const LoginScreen(),
                  "/popularmovies": (context) => const PopularScreen(),
                  "/detail" : (context) => const DetailPopularScreen(),
                  "/registro" : (context) => const RegistroScreen(),
                },
              ),
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
    } else {
      return ThemeSettings.personalizedTheme(context, fontFamily);
    }
  }
}
