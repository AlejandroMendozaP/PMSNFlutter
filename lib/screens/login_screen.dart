import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final conUser = TextEditingController();
  final conPwd = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    TextFormField txtUser = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: conUser,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person)
      ),
    );

    final txtPwd = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: conPwd,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.password)
      ),
    );

    final ctnCredentials = Positioned(
      bottom: 200,
      child: Container(
        width: MediaQuery.of(context).size.width*.9,
        //margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            txtUser,
            txtPwd
          ],
        ),
      ),
    );

    final btnLogin = Positioned(
      width: MediaQuery.of(context).size.width*.9,
      bottom: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 133, 161, 240),
        ),
        onPressed: (){
          isLoading = true;
          setState(() {});
          Future.delayed(
            const Duration(milliseconds: 4000)
          ).then((value) => {
            isLoading = false,
            setState(() {}),
            Navigator.pushNamed(context, "/home")
          });
        },
        child: const Text('Validar Usuario')
        ),
    );

    final gifLoading = Positioned(
      top: 120,
      height: 150,
      child: Image.asset('assets/sentidoaracnido.gif')
      );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/fondoSpiderman.jpg')
            )
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -50,
              child: Image.asset('assets/spidermanLogo.png', width: 400,)
              ),
              ctnCredentials,
              btnLogin,
              isLoading ? gifLoading : Container()
          ],
        ),
      ),
    );
  }
}