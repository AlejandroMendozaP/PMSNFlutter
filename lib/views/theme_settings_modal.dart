import 'package:flutter/material.dart';
import 'package:flutter_application_2/settings/global_values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSettingsModal extends StatefulWidget {
  const ThemeSettingsModal({Key? key}) : super(key: key);

  @override
  _ThemeSettingsModalState createState() => _ThemeSettingsModalState();
}

class _ThemeSettingsModalState extends State<ThemeSettingsModal> {
  String selectedTheme = 'Light'; // Tema seleccionado por defecto
  String selectedFont = 'Roboto';   // Fuente seleccionada por defecto

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // Cargar las preferencias al iniciar el modal
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTheme = prefs.getString('selectedTheme') ?? 'Light';
      selectedFont = prefs.getString('selectedFontFamily') ?? 'Roboto';
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', selectedTheme);
    await prefs.setString('selectedFontFamily', selectedFont);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Configuraciones de Tema y Fuente',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          ElevatedButton(
            onPressed: () {
              _savePreferences(); // Guardar preferencias al cerrar
              Navigator.pop(context);
            },
            child: const Text('Guardar Cambios'),
          ),
        ],
      ),
    );
  }
}
