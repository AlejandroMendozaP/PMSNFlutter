// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/personaje.dart';
import 'package:flutter_application_2/settings/colors_settings.dart';
import 'dart:math' as math;

class PersonajeCard extends StatelessWidget {
  Personaje personaje;
  double pageOffset;
  late double animation;
  double animate=0;
  double rotate=0;
  double columnAnimation=0;
  int index;

  PersonajeCard(this.personaje, this.pageOffset, this.index);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double cardWidth = size.width - 60;
    double cardHeight = size.height * .55;
    double count =0;
    double page;
    rotate =index -pageOffset;
    for(page=pageOffset;page>1;){
      page --;
      count ++;
    }
    animation =Curves.easeOutBack.transform(page);
    animate =100*(count+animation);
    columnAnimation =50*(count+animation);
    for(int i=0;i<index;i++){
      animate-=100;
      columnAnimation-=50;
    }


    return Container(
      child: Stack(
        clipBehavior: Clip.none, children: <Widget>[
          buildTopText(),
          buildBackgroundImage(cardWidth, cardHeight, size),
          buildAboveCard(cardWidth, cardHeight, size),
          buildCupImage(size),
          buildBlurImage(cardWidth, size),
          buildSmallImage(size),
          buildTopImage(cardWidth, size, cardHeight),
          buildAbilities(),
          buildInfoButton(context)
        ],
      ),
    );
  }

  Widget buildTopText() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Text(
            personaje.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: personaje.lightColor),
          ),
          Text(
            personaje.conName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: personaje.darkColor),
          ),
        ],
      ),
    );
  }

  Widget buildBackgroundImage(double cardWidth, double cardHeight, Size size) {
    return Positioned(
      width: cardWidth,
      height: cardHeight,
      bottom: size.height * .15,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(
            personaje.backgroundImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildAboveCard(double cardWidth, double cardHeight, Size size) {
    return Positioned(
      width: cardWidth,
      height: cardHeight,
      bottom: size.height * .15,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            color: personaje.darkColor.withOpacity(.50),
            borderRadius: BorderRadius.circular(25)),
        padding: EdgeInsets.all(30),
        child: Transform.translate(
          offset: Offset(-columnAnimation,0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Comic',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                personaje.description,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset('assets/arana_L.png'),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset('assets/arana_M.png'),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset('assets/arana_S.png'),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    color: ColorsSettings.lowRedColor, borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '\$',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '4.',
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                      Text(
                        '70',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCupImage(Size size) {
    return Positioned(
      bottom: 2,
      right: -size.width * .2 / 2 - 100,
      child: Transform.rotate(
        angle: -math.pi/14*rotate,
        child: Image.asset(
          personaje.cupImage,
          height: size.height * .55 - 15,
        ),
      ),
    );
  }

  Widget buildBlurImage(double cardWidth, Size size) {
    return Positioned(
      right: cardWidth / 2 - 60+animate,
      bottom: size.height * .10,
      child: Image.asset(
        personaje.imageBlur,
        height: 20,
      ),
    );
  }

  Widget buildSmallImage(Size size) {
    return Positioned(
      right: -10+animate,
      top: size.height * .3,
      child: Image.asset(personaje.imageSmall, height: 20,),
    );
  }

  Widget buildTopImage(double cardWidth, Size size, double cardHeight) {
    return Positioned(
      left: cardWidth / 4-animate,
      bottom: size.height * .15 + cardHeight - 25,
      child: Image.asset(personaje.imageTop, height: 20,),
    );
  }

  Widget buildAbilities() {
    return Positioned(
      top: 375,
      left: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Habilidades:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          SizedBox(height: 5),
          Text(
            personaje.abilities,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoButton(BuildContext context){
    return Positioned(
      top: 150,
      right: 10,
      child: IconButton(
        icon: Icon(
          Icons.info_outline,
          color: const Color.fromARGB(255, 255, 255, 255),
          size: 30,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: personaje.darkColor,
                title: Text(
                  'Más Información',
                  style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                content: Text(
                  personaje.extraInfo,
                  style: TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cerrar',
                      style: TextStyle(color: ColorsSettings.lowRedColor),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

