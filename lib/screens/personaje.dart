import 'package:flutter/material.dart';

class Personaje {
  String name;
  String conName;
  String backgroundImage;
  String imageTop;
  String imageSmall;
  String imageBlur;
  String cupImage;
  String description;
  String abilities;
  String extraInfo;
  Color lightColor;
  Color darkColor;

  Personaje(this.name, this.conName, this.backgroundImage,
            this.imageTop, this.imageSmall, this.imageBlur,
            this.cupImage, this.description, this.abilities, this.extraInfo,this.lightColor,
            this.darkColor);
}