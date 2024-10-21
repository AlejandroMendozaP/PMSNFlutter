import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/theme_settings_modal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _hobbyController = TextEditingController();
  double _completionLevel = 0;
  bool _isEditing = false;
  List<String> _hobbies = [];

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        _updateCompletionLevel();
      });
    }
  }

  void _updateCompletionLevel() {
    int filledFields = 0;
    if (_nameController.text.isNotEmpty) filledFields++;
    if (_emailController.text.isNotEmpty) filledFields++;
    if (_phoneController.text.isNotEmpty) filledFields++;
    if (_githubController.text.isNotEmpty) filledFields++;
    if (_imageFile != null) filledFields++;
    if (_hobbies.isNotEmpty)
      filledFields++; // Considerar hobbies como completado

    setState(() {
      _completionLevel = filledFields / 6; // Actualizado a 6 campos
    });
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': "Testing subject"},
    );
    await launchUrl(emailUri);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _launchInBrowserView(String username) async {
    final trimmedUsername = username.trim();

    var httpsUri = Uri(
      scheme: 'https',
      host: 'github.com',
      path: trimmedUsername,
    );

    if (!await launchUrl(
      httpsUri,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $httpsUri');
    }
  }

  void _toggleEditingMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _addHobby() {
    final hobby = _hobbyController.text.trim();
    if (hobby.isNotEmpty) {
      setState(() {
        _hobbies.add(hobby);
        _hobbyController.clear();
        _updateCompletionLevel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                WoltModalSheet.show(
                  context: context,
                  pageListBuilder: (context) =>
                      [WoltModalSheetPage(child: ThemeSettingsModal())],
                );
              },
              icon: const Icon(Icons.settings)),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      //backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Barra de Progreso de Nivel de Experiencia
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  Text(
                    'Perfil Completado: ${(_completionLevel * 100).toInt()}%',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _completionLevel,
                      minHeight: 12,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _completionLevel < 1.0 ? Colors.blue : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Avatar
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_isEditing) {
                      _showImageSourceActionSheet(context);
                    }
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _imageFile != null
                        ? FileImage(File(_imageFile!.path))
                        : null,
                    child: _imageFile == null
                        ? const Icon(Icons.camera_alt,
                            size: 50, color: Colors.grey)
                        : null,
                    backgroundColor: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _toggleEditingMode,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: _isEditing ? Colors.blue : Colors.grey,
                      child: Icon(
                        _isEditing ? Icons.check : Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Nombre Completo
            _buildProfileField(
              icon: Icons.person,
              label: 'Nombre Completo',
              controller: _nameController,
              onTap: _updateCompletionLevel,
              isEditing: _isEditing,
            ),
            // Correo
            _buildProfileField(
              icon: Icons.email,
              label: 'Correo',
              controller: _emailController,
              onTap: () => _launchEmail(_emailController.text),
              isEditing: _isEditing,
              isEmail: true,
            ),
            // Teléfono
            _buildProfileField(
              icon: Icons.phone,
              label: 'Teléfono',
              controller: _phoneController,
              onTap: () => _makePhoneCall(_phoneController.text),
              isEditing: _isEditing,
              isPhone: true,
            ),
            // GitHub
            _buildProfileField(
              icon: Icons.link,
              label: 'Usuario de GitHub',
              controller: _githubController,
              onTap: () => _launchInBrowserView(_githubController.text),
              isEditing: _isEditing,
            ),
            // Intereses/Hobbies
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Intereses/Hobbies',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: _hobbies.map((hobby) {
                      return Chip(
                        label: Text(hobby),
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        deleteIcon: _isEditing
                            ? Icon(Icons.close, color: Colors.red)
                            : null,
                        onDeleted: _isEditing
                            ? () {
                                setState(() {
                                  _hobbies.remove(hobby);
                                  _updateCompletionLevel();
                                });
                              }
                            : null,
                      );
                    }).toList(),
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _hobbyController,
                            decoration: const InputDecoration(
                              labelText: 'Agregar nuevo interés',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addHobby,
                          child: const Text('Agregar'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
    bool isEmail = false,
    bool isPhone = false,
    required bool isEditing,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: isEditing
            ? TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                ),
                keyboardType: isEmail
                    ? TextInputType.emailAddress
                    : isPhone
                        ? TextInputType.phone
                        : TextInputType.text,
                onChanged: (_) => _updateCompletionLevel(),
              )
            : Text(controller.text.isNotEmpty
                ? controller.text
                : 'Agregar $label'),
        onTap: isEditing ? null : onTap,
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Cámara'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
