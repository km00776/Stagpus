import 'package:flutter/material.dart';
import 'package:stagpus/Provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';

class UserCircle extends StatelessWidget {
  final User currentUser;

  const UserCircle({Key key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.amber,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              currentUser.displayName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
                fontSize: 13,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.purple, width: 2),
                  color: Colors.greenAccent),
            ),
          )
        ],
      ),
    );
  }
}
