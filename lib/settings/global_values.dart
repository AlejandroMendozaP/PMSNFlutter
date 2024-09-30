import 'package:flutter/material.dart';

class GlobalValues {
  //static ValueNotifier banThemeDark = ValueNotifier(false);
  static ValueNotifier<String> selectedTheme = ValueNotifier('Light'); // Nuevo: Para manejar el tema personalizado
  static ValueNotifier<String> selectedFontFamily = ValueNotifier('Roboto'); // Fuente predeterminada
  static ValueNotifier banUpdateListMovies = ValueNotifier(false);

}