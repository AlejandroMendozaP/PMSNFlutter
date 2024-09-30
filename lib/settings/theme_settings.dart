import 'package:flutter/material.dart';

class ThemeSettings {
  static ThemeData lightTheme(BuildContext context, String fontFamily) {
    final theme = ThemeData.light();
    return theme.copyWith(
      textTheme: Theme.of(context).textTheme.apply(fontFamily: fontFamily),
      //scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }

  static ThemeData darkTheme(BuildContext context, String fontFamily) {
    final theme = ThemeData.dark();
    return theme.copyWith(
      textTheme: Theme.of(context).textTheme.apply(fontFamily: fontFamily, bodyColor: Colors.white),
    );
  }

  static ThemeData personalizedTheme(BuildContext context, String fontFamily) {
    final theme = ThemeData.light(); // Basado en el tema claro
    return theme.copyWith(
      textTheme: Theme.of(context).textTheme.apply(
        fontFamily: fontFamily,
        bodyColor: Colors.black87, // Color del texto principal
      ),
      primaryColor: Colors.teal, // Cambia el color principal
      appBarTheme: AppBarTheme(
        color: Colors.teal.shade700, // Color de la AppBar
        iconTheme: IconThemeData(color: Colors.white), // Color de los iconos en la AppBar
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.teal, // Color de los botones
        textTheme: ButtonTextTheme.primary, // Texto en los botones
      ),
      scaffoldBackgroundColor: Colors.teal.shade50, // Color de fondo de la aplicación
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.tealAccent.shade400, // Color del botón flotante
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.teal.shade100, // Color de los campos de texto
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade700),
        ),
      ),
    );
  }
}