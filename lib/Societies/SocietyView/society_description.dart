import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:stagpus/Societies/SocietyModel/Society.dart';
import 'package:stagpus/Societies/SocietyView/colors.dart';
import 'package:stagpus/Societies/SocietyView/society_main.dart';


class SocietyDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kActiveIconColor,
      //appBar: detailsAppBar(),
      body: SocietyBody(),
      
      );
  }
  
}

class SocietyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Column(
     children: <Widget> [
     //  ItemImage(imgSrc: ""),
     Expanded(
       child: SocietyInfo()
       )
     ],
   );
  }
    
}

class SocietyInfo extends StatelessWidget {

  const SocietyInfo({Key key, }): super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)
        ),
      ),
      child: Column(children: <Widget> [
        societyName(name: "Test"),
        
        Text("Tesint the society page",
          style: TextStyle(
            height: 1.5,
          )
        ),
        SizedBox(height: size.height * 0.1),
        //OrderButton(size: size, press: (){})
      ],)
    );
    
  }

  Row societyName({String name}) {
    return Row(children: <Widget> [
      Icon(
      Icons.location_on,
      color: Colors.black12,
      ),
      SizedBox(width: 10),
      Text(name)
    ],);
  }
  
}