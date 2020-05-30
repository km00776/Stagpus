import 'package:flutter/material.dart';

const mainBgColor = Color(0xFFf2f2f2);
const darkColor = Color(0xFF03254C);
const midColor = Color(0xFF1167B1);
const lightColor = Color(0xFFD0EFFF);
const darkRedColor = Color(0xFF1184E8);
const lightRedColor = Color(0xFF7ECFD4);

const purpleGradient = LinearGradient(
  colors: <Color>[darkColor, midColor, lightColor],
  stops: [0.0, 0.5, 1.0],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const redGradient = LinearGradient(
  colors: <Color>[darkRedColor, lightRedColor],
  stops: [0.0, 1.0],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const USER_IMAGE='https://cdn4.iconfinder.com/data/icons/people-avatar-flat-1/64/girl_chubby_beautiful_people_woman_lady_avatar-512.png';