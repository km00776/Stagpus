import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


AppBar header(context) {
  return AppBar(
  title: Text(
    "StagPus",
    style: TextStyle(
      color: Colors.white,
      fontFamily: "Signatra",
      fontSize: 50.0
    ),
  ),
  centerTitle: true,
  backgroundColor: Theme.of(context).accentColor,
  );
}
