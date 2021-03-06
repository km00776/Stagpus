import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

  AppBar header(context,{bool isAppTitle = false, String titleText, bool removeBackButton = false, Icon icon}) {
  return AppBar(
  automaticallyImplyLeading: removeBackButton ? false : true,
  title: Text(
    isAppTitle ? "StagPus": titleText,
    style: TextStyle(
      color: Colors.white,
      fontFamily: isAppTitle ? "Signatra" : "",
      fontSize: isAppTitle ? 50.0 : 22.0
    ),
    overflow: TextOverflow.ellipsis,
  ),
  centerTitle: true,
  backgroundColor: Theme.of(context).accentColor, 
   );
}

