import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stagpus/pages/activity_feed.dart';
import 'package:stagpus/pages/profile.dart';
import 'package:stagpus/pages/search.dart';
import 'package:stagpus/pages/timeline.dart';
import 'package:stagpus/pages/upload.dart';

class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  PageController pageController = null;
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
        return dashBoard();
    }
    @override
    void initState(){
        super.initState();
        pageController = PageController();

    }

    void onPageChanged(int pageIndex) {
      setState(() {
        this.pageIndex = pageIndex;
      });
    }
     void onTap(int pageIndex) {
          pageController.jumpToPage(pageIndex,); 
    }
    Scaffold dashBoard() {
      return Scaffold(
        body: PageView(
          children: <Widget>[
            Timeline(),
            ActivityFeed(),
            Upload(),
            Search(),
            Profile(),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.whatshot),),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_active),),
            BottomNavigationBarItem(icon: Icon(Icons.photo_camera, size: 35.0,),),
            BottomNavigationBarItem(icon: Icon(Icons.search),),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle),),
          ],
          ),
      );
    }

    
}