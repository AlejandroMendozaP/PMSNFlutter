// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_application_2/settings/global_values.dart';
import 'package:flutter_application_2/settings/theme_settings.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  final Color kDarkBlueColor = const Color(0xFF053149);
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String selectedTheme = 'Light';  // Tema seleccionado por defecto
  String selectedFont = 'Roboto';  // Fuente seleccionada por defecto

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Start',
      onFinish: () {
        Navigator.pushNamed(context, "/home");
      },
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: widget.kDarkBlueColor,
      ),
      skipTextButton: Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          //color: widget.kDarkBlueColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        Navigator.pushNamed(context, "/home");
      },
      controllerColor: widget.kDarkBlueColor,
      totalPage: 3,
      headerBackgroundColor: const Color.fromARGB(0, 255, 255, 255),
      //pageBackgroundColor: Colors.white,
      background: [
        Lottie.asset('assets/spider.json', height: 400),
        Lottie.asset('assets/theme.json', height: 400),
        Lottie.asset('assets/done.json', height: 400)
      ],
      speed: 1.8,
      pageBodies: [
        // Página 1: Explicación del funcionamiento de la app
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          margin: const EdgeInsets.only(bottom: 250),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'Bienvenido a la App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  //color: widget.kDarkBlueColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Aquí te mostramos cómo usar nuestra aplicación.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  //color: Colors.black26,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        // Página 2: Selección del tema y la fuente
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
                  //color: widget.kDarkBlueColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              // Selector de tema
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
                    GlobalValues.selectedTheme.value = selectedTheme;  // Actualizamos el tema global
                  });
                },
              ),
              const SizedBox(height: 20),
              // Selector de fuente
              DropdownButton<String>(
                value: selectedFont,
                items: const [
                  DropdownMenuItem(
                    value: 'Roboto',
                    child: Text('Roboto'),
                  ),
                  DropdownMenuItem(
                    value: 'Segoe Ul',
                    child: Text('Segoe UI'),
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
                    //GlobalValues.banThemeDark.value = GlobalValues.banThemeDark.value;
                    GlobalValues.selectedTheme.value = GlobalValues.selectedTheme.value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                '¡Haz que la personalización sea de tu agrado!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  //color: Colors.black26,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        // Página 3: Pantalla adicional con botón para ir a /home
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          margin: const EdgeInsets.only(bottom: 250),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '¡Todo está listo para comenzar!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  //color: widget.kDarkBlueColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Haz clic en el botón para comenzar a usar la app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  //color: Colors.black26,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
