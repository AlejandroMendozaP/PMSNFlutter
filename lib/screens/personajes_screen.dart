import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/personaje.dart';
import 'package:flutter_application_2/screens/personaje_card.dart';
import 'package:flutter_application_2/settings/colors_settings.dart';

class PersonajesScreen extends StatefulWidget {
  const PersonajesScreen({super.key});

  @override
  State<PersonajesScreen> createState() => _PersonajesScreenState();
}

class _PersonajesScreenState extends State<PersonajesScreen> with SingleTickerProviderStateMixin{

  late PageController pageController;
  double pageOffset=0;
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOutBack);
    pageController = PageController(viewportFraction:.8);
    pageController.addListener((){
      setState(() {
        pageOffset=pageController.page!;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            buildToolBar(),
            buildLogo(size),
            buildPager(size),
            buildPageIndicator(),
          ],
        )
        ),
    );
  }

  Widget buildToolBar() {
    return Padding(
      padding:const EdgeInsets.only(top: 20.0),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 20,),
          AnimatedBuilder(
            animation: animation,
            builder: (context, snapshot) {
              return Transform.translate(
                offset: Offset(-200 * (1.0 - animation.value), 0),
                child: Image.asset('assets/anterior.png', width: 30, height: 30,)
                );
            }
          ),
          const Spacer(),
          AnimatedBuilder(
            animation: animation,
            builder: (context, snapshot) {
              return Transform.translate(
                offset: Offset(200 * (1.0 - animation.value), 0),
                child: Image.asset('assets/menu.png', height: 30, width: 30,)
                );
            }
          ),
          const SizedBox(width: 20,)
        ],
      ),
    );
  }

  Widget buildLogo(Size size) {
    return Positioned(
      top: 10,
      right: size.width/2-25,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, snapshot) {
          return Transform(
            transform: Matrix4.identity()
            ..translate(0.0,size.height/2*(1-animation.value))
            ..scale(1 + (1 - animation.value)),
            origin: Offset(25, 25),
            child: InkWell(
              onTap: () => controller.isCompleted
                  ? controller.reverse()
                  : controller.forward(),
              child: Image.asset('assets/logoSpiderman.png', width: 50, height: 50,))
            );
        }
      ),
    );
  }

  Widget buildPager(Size size) {
    return Container(
      margin: EdgeInsets.only(top: 70),
      height: size.height-50,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, snapshot) {
          return Transform.translate(
            offset: Offset(400 * (1.0 - animation.value), 0),
            child: PageView.builder(
              controller:pageController,
              itemCount: getPersonaje().length,
              itemBuilder: (context, index)=>PersonajeCard(getPersonaje()[index], pageOffset, index)
              ),
          );
        }
      ),
    );
  }

  List<Personaje> getPersonaje(){
    List<Personaje> list = [];
    list.add(Personaje(
        'Spider',
        'Man',
        'assets/spiderblur.jpg',
        'assets/2099logo.png',
        'assets/2099logo.png',
        'assets/telarana.png',
        'assets/spiderman.png',
        'El clásico héroe de Nueva York, siempre listo para proteger la ciudad. Peter Parker, el Spiderman original.',
        'Poderes de araña',
        'Identidad secreta: Peter Parker',
        ColorsSettings.redColor,
        ColorsSettings.blueColor));
    list.add(Personaje(
        'Spider-Man',
        '2099',
        'assets/2099Blur.jpg',
        'assets/2099logo.png',
        'assets/2099logo.png',
        'assets/telarana.png',
        'assets/spider-man-2099.png',
        'En el futuro, el héroe arácnido sigue luchando por la justicia. Conoce a Spiderman 2099',
        'Colmillos, Poderes de araña',
        'Identidad secreta: Miguel Ohara',
        ColorsSettings.redColor,
        ColorsSettings.blueColor));
    list.add(Personaje(
        'Ve',
        'nom',
        'assets/venomBlur.jpg',
        'assets/2099logo.png',
        'assets/2099logo.png',
        'assets/2099logo.png',
        'assets/venom3.png',
        'Un rival letal y antihéroe impredecible. Venom, el simbionte que desafía a todos, incluso a Spiderman.',
        'Regeneración, Poderes de araña',
        'Identidad secreta: Eddie Brock',
        ColorsSettings.purple2Color,
        ColorsSettings.purpleColor));
    return list;
  }
  
  Widget buildPageIndicator() {
    return AnimatedBuilder(
      animation:controller,
      builder: (context, snapshot) {
        return Positioned(
          bottom: 10,
          left: 10,
          child: Opacity(
            opacity: controller.value,
            child: Row(
              children:
                  List.generate(getPersonaje().length, (index) => buildContainer(index)),
            ),
          ),
        );
      }
    );
  }

  Widget buildContainer(int index) {
    double animate =pageOffset-index;
    double size =10;
    animate=animate.abs();
    Color? color =const Color.fromARGB(255, 79, 117, 241);
    Color? colorEnd =const Color.fromARGB(255, 245, 69, 69);
    if(animate<=1 && animate>=0){
      size=10+10*(1-animate);
      color =ColorTween(begin: color,end: colorEnd).transform((1-animate));
    }

    return Container(
      margin: EdgeInsets.all(4),
      height: size,
      width: size,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(20)),
    );
  }
}