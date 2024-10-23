// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_application_2/settings/global_values.dart';
import 'package:flutter_application_2/settings/theme_settings.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  final Color kDarkBlueColor = const Color(0xFF053149);
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String selectedTheme = 'Light';  // Tema seleccionado por defecto
  String selectedFont = 'Roboto';  // Fuente seleccionada por defecto

  // Función para guardar las preferencias seleccionadas
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', selectedTheme);
    await prefs.setString('selectedFontFamily', selectedFont);
  }

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Start',
      onFinish: () {
        _savePreferences();  // Guardamos las preferencias seleccionadas
        Navigator.pushNamed(context, "/home");
      },
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: widget.kDarkBlueColor,
      ),
      skipTextButton: Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        _savePreferences();  // Guardamos las preferencias seleccionadas
        Navigator.pushNamed(context, "/home");
      },
      controllerColor: widget.kDarkBlueColor,
      totalPage: 3,
      headerBackgroundColor: const Color.fromARGB(0, 255, 255, 255),
      background: [
        Lottie.asset('assets/spider.json', height: 400),
        Lottie.asset('assets/theme.json', height: 400),
        Lottie.asset('assets/done.json', height: 400)
      ],
      speed: 1.8,
      pageBodies: [
        // Página 1
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          margin: const EdgeInsets.only(bottom: 250),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const <Widget>[
              Text(
                'Bienvenido a la App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Aquí te mostramos cómo usar nuestra aplicación.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        // Página 2: Selección de tema y fuente
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          margin: const EdgeInsets.only(bottom: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'Es momento de configurar tu tema y fuente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedTheme,
                items: const [
                  DropdownMenuItem(
                    value: 'Light',
                    child: Text('Tema Claro'),
                  ),
                  DropdownMenuItem(
                    value: 'Dark',
                    child: Text('Tema Oscuro'),
                  ),
                  DropdownMenuItem(
                    value: 'Custom',
                    child: Text('Tema Personalizado'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTheme = newValue!;
                    GlobalValues.selectedTheme.value = selectedTheme;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedFont,
                items: const [
                  DropdownMenuItem(
                    value: 'Roboto',
                    child: Text('Roboto'),
                  ),
                  DropdownMenuItem(
                    value: 'Times New Roman',
                    child: Text('Times New Roman'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFont = newValue!;
                    GlobalValues.selectedFontFamily.value = selectedFont;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                '¡Haz que la personalización sea de tu agrado!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        // Página 3
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          margin: const EdgeInsets.only(bottom: 250),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const <Widget>[
              Text(
                '¡Listo! Ya puedes empezar a usar la app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
