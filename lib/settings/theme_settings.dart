import 'package:flutter/material.dart';

class ThemeSettings {

  static ThemeData lightTheme(BuildContext context){
    final theme = ThemeData.light();
    return theme.copyWith(
      scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }

  static ThemeData darkTheme(){
    final theme = ThemeData.dark();
    return theme.copyWith(
      scaffoldBackgroundColor: const Color.fromARGB(255, 46, 46, 46),
    );
  }

  static ThemeData warmTheme(){
    final theme = ThemeData();
    return theme.copyWith();
  }
}