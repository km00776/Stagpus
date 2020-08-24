import 'package:flutter/material.dart';

const mainBgColor = Color(0xFFf2f2f2);
const darkColor = Color(0xFF2E5984);
const midColor = Color(0xFF528AAE);
const lightColor = Color(0xFF91BAD6);

const purpleGradient = LinearGradient(
  colors: <Color>[darkColor, midColor, lightColor],
  stops: [0.0, 0.5, 1.0],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const DUMMY_IMAGE =
    'https://cdn4.iconfinder.com/data/icons/people-avatar-flat-1/64/girl_chubby_beautiful_people_woman_lady_avatar-512.png';
