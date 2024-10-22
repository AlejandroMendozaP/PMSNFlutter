import 'package:flutter/material.dart';
import 'package:flutter_application_2/firebase/email_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  EmailAuth auth = EmailAuth();
  final conUser = TextEditingController();
  final conPwd = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/fondoSpiderman.jpg'),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: constraints.maxHeight * 0.1,
                  child: Image.asset(
                    'assets/spidermanLogo.png',
                    width: constraints.maxWidth * 0.6, // Ajustar tamaño en función de la pantalla
                  ),
                ),
                // Caja de credenciales
                Positioned(
                  bottom: constraints.maxHeight * 0.35, // Ajustar la posición
                  child: Container(
                    width: constraints.maxWidth * 0.9, // Responsivo al ancho de la pantalla
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: conUser,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Usuario',
                          ),
                        ),
                        const SizedBox(height: 16), // Espacio entre los campos
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: conPwd,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            hintText: 'Contraseña',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Botón de login
                Positioned(
                  bottom: constraints.maxHeight * 0.18, // Ajustar la posición
                  child: SizedBox(
                    width: constraints.maxWidth * 0.9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 133, 161, 240),
                      ),
                      onPressed: () {
                        auth.validateUser(conUser.text, conPwd.text).then((value) {
                          setState(() {
                          isLoading = true;
                          });
                          Future.delayed(const Duration(milliseconds: 4000)).then((value) {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pushNamed(context, "/onboarding");
                          });
                        });
                      },
                      child: const Text('Validar Usuario'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: constraints.maxHeight * 0.1, // Ajustar la posición
                  child: SizedBox(
                    width: constraints.maxWidth * 0.9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 133, 161, 240),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/registro");
                      },
                      child: const Text('Registrarse'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
