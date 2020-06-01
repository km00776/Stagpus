import 'package:flutter/material.dart';
import 'package:stagpus/Clubs/ModelClubs/Club.dart';
import 'package:stagpus/Marketplace/ViewMarket/MarketColours.dart';
import 'package:stagpus/models/user.dart';



class Club extends StatefulWidget {
  User currentUser;

  @override
  ClubsState createState() => ClubsState();
}

class ClubsState extends State<Club> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
          body: SingleChildScrollView(child:Container(
        color: blueColor,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(40),
                  constraints: BoxConstraints.expand(height: 225),
                  decoration: BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.topRight,
             end: Alignment.bottomLeft,
             colors: [Colors.blueAccent, Colors.cyan])
         ),
                  child: Container(
                    padding: EdgeInsets.only(top: 50),
                    constraints: BoxConstraints.expand(height:225),
                    decoration: BoxDecoration(
                       gradient: LinearGradient(
             begin: Alignment.topRight,
             end: Alignment.bottomLeft,
             colors: [Colors.blueAccent, Colors.cyan])
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Join a club or Society now!', style: titleStyleWhite,)
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 120),
                  constraints: BoxConstraints.expand(height:200),
                  child: ListView(
                    padding: EdgeInsets.only(left: 40),
                    scrollDirection: Axis.horizontal,
                    children: getRecentJobs()
                  ),
                ),
                Container(
                  height: 500,
                  margin: EdgeInsets.only(top: 300),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: Text(
                          "Explore New Opportunities",
                          style: titileStyleBlack, 
                          ),
                      ),
                      Container(
                        height: 400,
                        child: ListView(
                          children: getJobCategories(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
          ),
    );
  }
  List<String> jobCategories = ["Clubs", "Societies"];

  Map jobCatToIcon = {
    "Sales" : Icon(Icons.monetization_on, color: lightBlueIsh, size: 50,),
    "Engineering" : Icon(Icons.settings, color: lightBlueIsh, size: 50),
    "Health" : Icon(Icons.healing, color: lightBlueIsh, size: 50),
    "Education" : Icon(Icons.search, color: lightBlueIsh, size: 50),
    "Finance" : Icon(Icons.card_membership, color: lightBlueIsh, size: 50),
  };

  Widget getCategoryContainer(String categoryName) {
    return new Container(
          margin: EdgeInsets.only(right: 10, left: 10, bottom: 20),
          height: 180,
          width: 140,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              new BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Text(categoryName, style: titileStyleLighterBlack),
              Container(
                padding: EdgeInsets.only(top: 30),
                height: 100,
                width: 70,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child:  jobCatToIcon[categoryName],
                  elevation: 10,
                  onPressed: () {

                  },
                ),
              )
            ],
          ),
        );
  }

  List<Widget> getJobCategories() {
    List<Widget> jobCategoriesCards = [];
    List<Widget> rows = [];
    int i = 0;
    for (String category in jobCategories) {
      if (i < 2) {
        rows.add(getCategoryContainer(category));
        i ++;
      } else {
        i = 0;
        jobCategoriesCards.add(new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rows,
        ));
        rows = [];
        rows.add(getCategoryContainer(category));
        i++;
      }
    }
    if (rows.length > 0) {
      jobCategoriesCards.add(new Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: rows,
        ));
    }
    return jobCategoriesCards;
  }


  List<Society> findJobs() {
    List<Society> club = [];
    for (int i = 0; i < 10; i++) {
        club.add(new Society('Boxing', 'Join now for fee!'));
        club.add(new Society('MMA', 'Join now for fee!'));
        club.add(new Society('karate', 'Join now for fee!'));
        club.add(new Society('Chess', 'Join now for fee!'));
        club.add(new Society('Compsoc', 'Join now for fee!'));
    }
    return club;
  }
  

  

  
  List<Widget> getRecentJobs() {
    List<Widget> recentJobCards = [];
    List<Society> club = findJobs();
    for (Society clubs in club) {
      recentJobCards.add(getJobCard(clubs));
    }
    return recentJobCards;
  }



  Widget getJobCard(Society clubs) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 20, bottom: 30, top: 30),
      height: 150,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          new BoxShadow(
            color: Colors.grey,
            blurRadius: 20.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
               clubs.clubName,
               style: jobCardTitileStyleBlue,
              )
            ],
          ),
          Text("Boxing" + " - " + "Mondy", style: jobCardTitileStyleBlack),
          Text("text"),
        
        ],
      ),
    );
  }
}