import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stagpus/Events/EventsView/colors.dart';
import 'package:stagpus/Societies/SocietyView/colors.dart';

class SocietyCategoryCard extends StatelessWidget {
 
  final String title;
  final Function press;
  final String mediaURL;

  const SocietyCategoryCard({
    Key key,
    this.mediaURL,
    this.title,
    this.press, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 17),
              blurRadius: 17,
              spreadRadius: -23,
              color: kShadowColor,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  CircleAvatar(
                  backgroundColor: Color(0xFFD9D9D9),
                  backgroundImage: NetworkImage(mediaURL),
                  radius: 36.0,
                ),
                  Spacer(),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        // ignore: deprecated_member_use
                        .title
                        .copyWith(fontSize: 15),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
