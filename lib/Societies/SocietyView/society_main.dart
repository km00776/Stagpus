import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stagpus/Events/EventsView/colors.dart';
import 'package:stagpus/Societies/SocietyView/Category.dart';
import 'package:stagpus/Societies/SocietyView/society_description.dart';
import 'package:stagpus/Societies/SocietyView/society_search.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';


class SocietyScreen extends StatelessWidget {
  User currentUser;
  SocietyScreen({this.currentUser});
   @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //helps us retrieve the size of the device. 
    return Scaffold(  
      body: Stack(
        children: <Widget>[
          Container(
            //resizing the dimensions, 
            height: size.height * .45,
            decoration: BoxDecoration(
              color: Color(0xFF035AA6),
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: Color(0xFF035AA6),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset("assets/icons/menu.svg"),
                    ),
                  ),
                  Text(
                    "Good Mornign " + currentUser.displayName,
                    style: Theme.of(context)
                        .textTheme
                        // ignore: deprecated_member_use
                        .display1
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                 

                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        SocietyCategoryCard(
                          title: "WeightLifting",
                          mediaURL: 'https://cdn1.iconfinder.com/data/icons/SummerOlympics/128/weightlifting_px.png',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return SocietyDetailsScreen(
                                  myText: "Pick up weights with us!",
                                );
                              }),
                            );
                          },
                        ),
                        SocietyCategoryCard(
                          title: "Computer Science ",
                          mediaURL: 'https://cdn4.iconfinder.com/data/icons/creative-process-16/512/Responsive_Design-512.png',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return SocietyDetailsScreen(
                                  myText: "Welcome to the computer science society",
                                );
                              }),
                            );
                          },
                        ),
                        SocietyCategoryCard(
                          title: "boxing",
                           mediaURL: 'https://cdn1.iconfinder.com/data/icons/IconsLandVistaPeopleIconsDemo/256/Boxer_Male_Light.png',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return SocietyDetailsScreen(
                                  myText: "Join boxing to learn how to defend yourself",
                                );
                              }),
                            );
                          },
                        ),
                        SocietyCategoryCard(
                          title: "Yoga",
                          mediaURL: 'https://cdn2.iconfinder.com/data/icons/exercise-3/185/exercise-03-512.png',
                          press: () {
                            
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
