import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:stagpus/Marketplace/ControllerMarket/MarketController.dart';
import 'package:stagpus/Marketplace/ModelMarket/Option.dart';
import 'package:stagpus/Marketplace/ViewMarket/item_card_shape.dart';


const Color blueColor = const Color(0xCC2372F0);
const Color mintColor = const Color(0xADEFD1FF);
const Color iconBackgroundColor = const Color(0xFF647082);
final BorderRadius optionBorderRadius = BorderRadius.circular(8);

class MarketPlace extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: mintColor,
      body: Stack(
        children: <Widget> [
          Background(width: width * 0.4, 
          height: height * 0.8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50,),
              UniqueAppBar(),
              SizedBox(height:30,),
              Title(
                text: "SurreyU Market"
              ),
              SizedBox(height:30,),
              SettingsAndOptions(),
              SizedBox(height:30,), 
              ItemsWidget(items: controllers, screenWidth: width, screenHeight: height,)

            ],
          )
        ]
      )
    );
  }
  
}

class Title extends StatelessWidget {
  final String text;

  const Title({Key key, this.text}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: words[0],
              style: TextStyle(
                height: 0.8,
                fontWeight: FontWeight.w900,
                fontSize: 36,
                letterSpacing: 2,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: '\n',
            ),
            TextSpan(
              text: words[1],
              style: TextStyle(
                height: 0.85,
                fontWeight: FontWeight.w900,
                letterSpacing: 10,
                fontFamily: 'Londrina_Outline',
                color: Colors.black,
              )

            ),
          ]
        )


    )
    );
  }
}

class UniqueAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 16),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: <Widget>[
         ClayContainer(
           height: 50,
           width: 50,
           spread: 20,
           depth: 2,
           borderRadius: 25,
           curveType: CurveType.concave, 
           child: Container (
             decoration: BoxDecoration(
               border: Border.all(color: const Color(0x22647082), width: 2),
               borderRadius: BorderRadius.circular(25)
             ),
             child: Icon(
               Icons.menu,
               color: iconBackgroundColor,
               size: 25,
             )
           ),
         ),
          ClayContainer(
           height: 50,
           width: 50,
           spread: 20,
           depth: 2,
           borderRadius: 25,
           parentColor: blueColor,
           curveType: CurveType.concave, 
           child: Container (
             decoration: BoxDecoration(
               border: Border.all(color: const Color(0x33647082), width: 2),
               borderRadius: BorderRadius.circular(25)
             ),
             child: Icon(
               Icons.shopping_cart,
               color: iconBackgroundColor,
               size: 25,
             )
           ),
         )
       ],
     )
   );
  }
}

class SettingsAndOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.short_text,
            color: iconBackgroundColor,
            size: 50,
          ),
          SizedBox(
            width: 20,
          ),
          
          OptionsWidget(
            selectedOptionId: 1,
          ),
        ],
      )
    );
  }
  
}
class ItemsWidget extends StatelessWidget {
  final List<Item> items;
  final double screenWidth, screenHeight;

  const ItemsWidget({Key key, this.items, this.screenWidth, this.screenHeight}) : super(key: key);

  Widget build(BuildContext context) {
  return SizedBox(
    height: screenHeight * 0.42,
    child: PageView.builder(
      itemCount: items.length,
      controller: PageController(viewportFraction: 0.7),
      itemBuilder: (context , index) {
        return Stack(
          children: <Widget>[
            Material(
              elevation: 10,
              shape: ItemCardShape(
              screenWidth * 0.65, 
              screenHeight * 0.38
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Align(
                alignment: Alignment(0, -0.1),
                child: Image.asset(items[index].imagePath),
              ),
            ),
            Positioned(
                bottom: 50,
                left: 32,
                right: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Text(
                    items[index].title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    items[index].description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                  ]
                )
              ),
          ]
        );
      }
    )
    );
  }
  }



class OptionsWidget extends StatelessWidget {
  final int selectedOptionId;

  const OptionsWidget({Key key, this.selectedOptionId}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          for (int i = 0; i < options.length; i++)
          OptionWidget(option: options[i], isSelected: options[i].id == selectedOptionId),


        ],
      )
    );
  }
}

class OptionWidget extends StatelessWidget {
  final Option option;
  final bool isSelected;

  const OptionWidget({Key key, @required this.option, this.isSelected = false}) : super(key: key);

  
  
    @override
    Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        elevation: 0,
        borderRadius: optionBorderRadius,
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: optionBorderRadius,
            color: isSelected ? iconBackgroundColor : Colors.white, 
          ),
          child: Image.asset(option.imagePath, 
          color: isSelected ? Colors.white : iconBackgroundColor),
        ),
      ),
      );
    }
    
  }
  
 

class Background extends StatelessWidget {
  final double width,height;
  const Background({Key key, this.width, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 0,
        width: width,
        top: 0,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
          child: ColoredBox(
            color: blueColor,
            ),
          )
        );
    
  }
}