import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Marketplace/ModelMarket/Product.dart';
import 'package:stagpus/Marketplace/ViewMarket/Details_Screen.dart';
import 'package:stagpus/Marketplace/ViewMarket/MarketColours.dart';
import 'package:stagpus/Marketplace/ViewMarket/category_list.dart';
import 'package:stagpus/Marketplace/ViewMarket/product_card.dart';
import 'package:stagpus/Marketplace/ViewMarket/search_market.dart';
import 'package:stagpus/Marketplace/ViewMarket/sell_screen_form.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/resources/FirebaseMethods.dart';
import 'package:stagpus/resources/FirebaseRepo.dart';
import 'package:stagpus/widgets/progress.dart';

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

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  getProducts() async {
    QuerySnapshot snapshot = await productCollectionRef
        .document("users")
        .collection('userProducts')
        .getDocuments();
    List<Product> products =
        snapshot.documents.map((doc) => Product.fromDocument(doc)).toList();
    setState(() {
      this.productList = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: marketColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              SearchMarket(productList: productList),
              CategoryList(),
              SizedBox(height: kDefaultPadding / 2),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    StreamBuilder(
                        stream: productCollectionRef
                            .document("users")
                            .collection("userProducts")
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data == null) {
                            return circularProgress();
                          }
                          List<Product> products = snapshot.data.documents
                              .map((doc) => Product.fromDocument(doc))
                              .toList();

                          return Container(
                            child: ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (context, index) => ProductCard(
                                mediaUrl: products[index].mediaUrl,
                                currentUser: currentUser,
                                itemIndex: index,
                                product: products[index],
                                press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                        product: products[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            margin: EdgeInsets.only(top: 70),
                            decoration: BoxDecoration(
                              color: kBackgroundColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text("Surrey Market"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.plus_one),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SellScreen(currentUser: currentUser)));
            },
            color: Colors.amber[300],
          )
        ]);
  }
}
