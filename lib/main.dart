// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/home_screed.dart';
import 'package:flutter_application_2/screens/login_screen.dart';
import 'package:flutter_application_2/screens/movies_screen.dart';
import 'package:flutter_application_2/screens/personajes_screen.dart';
import 'package:flutter_application_2/settings/global_values.dart';
import 'package:flutter_application_2/settings/theme_settings.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalValues.banThemeDark,
      builder: (context, _,value) { //el guion bajo descarta el parametro
        return MaterialApp(
          title: 'Material App',
          //theme: ThemeData.dark(),
          theme:GlobalValues.banThemeDark.value ? ThemeSettings.darkTheme() : ThemeSettings.lightTheme(context),
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
          routes: {
            "/home" : (context) => HomeScreen(),
            "/personajes" : (context) => PersonajesScreen(),
            "/movies" : (context) => MoviesScreen()
          },
        );
      }
    );
  }
}
