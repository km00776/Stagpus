import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Marketplace/ModelMarket/Product.dart';
import 'package:stagpus/Marketplace/ViewMarket/Details_Screen.dart';
import 'package:stagpus/Marketplace/ViewMarket/MarketColours.dart';
import 'package:stagpus/Marketplace/ViewMarket/category_list.dart';
import 'package:stagpus/Marketplace/ViewMarket/product_card.dart';
import 'package:stagpus/Marketplace/ViewMarket/search_market.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/resources/FirebaseMethods.dart';
import 'package:stagpus/resources/FirebaseRepo.dart';

final productCollectionRef = Firestore.instance.collection("products");

class ProductScreen extends StatefulWidget {
  final User currentUser;

  ProductScreen({this.currentUser});
  @override
  ProductScreenState createState() => ProductScreenState();
}



class ProductScreenState extends State<ProductScreen> {
  FirebaseMethods m1 = new FirebaseMethods();
  FirebaseRepository r = new FirebaseRepository();
  List<Product> productList;
  String productId;
  String price;
  String productName;
  String description;



  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: marketColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              SearchMarket(onChanged: (value) {}),
              CategoryList(),
              SizedBox(height: kDefaultPadding / 2),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    // Our background
                    Container(
                      margin: EdgeInsets.only(top: 70),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                    ),

                    ListView.builder(
                      itemCount: productList.length,
                      itemBuilder: (context, index) => ProductCard(
                        itemIndex: index,
                        product: productList[index],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                product: productList[index],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    r.getCurrentUser().then((FirebaseUser user) {
      r.fetchAllProducts(user).then((List<Product> products) {
        setState(() {
          productList = products;
        });
      });
    });
  }

  AppBar buildAppBar() {
    return AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text("tests"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
            color: Colors.amber[300],
          )
        ]);
  }
}


