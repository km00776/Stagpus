import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:stagpus/widgets/progress.dart';

class ProductScreen extends StatelessWidget {
  Product product;
  User currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: marketColor,
      body: Body(),
      );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: Text('SurreyMarket'),
      actions: <Widget> [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {},
          color: Colors.amber[300],
        )
      ]
    );
  }
}

getProducts() async {
    QuerySnapshot snapshot = await productCollectionRef.document(currentUser.uid).collection('userProducts').getDocuments();
    List<Product> products = snapshot.documents.map((doc) => Product.fromDocument(doc)).toList();
    
}



class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          SearchMarket(onChanged: (value) {
            
          }),
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
                FutureBuilder(
                   future: productCollectionRef.document(currentUser.uid).get(),
                   builder: (context, snapshot) {
                     if(!snapshot.hasData) {
                       return circularProgress();
                     }
                     Product product = Product.fromDocument(snapshot.data);
                     
                     ListView.builder(
                      itemCount: product.toString().length,
                      itemBuilder: (context,index) => ProductCard(
                      itemIndex: index,
                      product: product,


                       ),
                       );
                     
                   }


                
                // ListView.builder(
                //   // here we use our demo procuts list
                //   itemCount: products.length,
                //   itemBuilder: (context, index) => ProductCard(
                //     itemIndex: index,
                //     product: products[index],
                //     press: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => DetailsScreen(
                //             product: products[index],
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}