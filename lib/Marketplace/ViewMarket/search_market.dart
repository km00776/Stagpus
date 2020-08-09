import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Marketplace/ModelMarket/Product.dart';
import 'package:stagpus/Marketplace/ViewMarket/Details_Screen.dart';
import 'package:stagpus/Marketplace/ViewMarket/MarketColours.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/widgets/progress.dart';


 

class SearchMarket extends StatefulWidget {
  @override
  _SearchMarketState createState() => _SearchMarketState();
  
  }
  
class _SearchMarketState extends State<SearchMarket>  {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;


  handleSearch(String query) {
    Future<QuerySnapshot> products = productCollectionRef.where("productName", isLessThanOrEqualTo: query).getDocuments();
    setState(() {
      searchResultsFuture = products;
    });
  }

  clearSearch() {
    searchController.clear();
  }
  
  Container buildNoContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blueAccent, Colors.cyan]
        )
      ),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget> [
            Text(
              "Find Various Products",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0
              )
            )
          ]
        )
      )
    );
  }

  buildProductSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return circularProgress();
        }
        List<ProductResult> searchResults = [];
                snapshot.data.documents.forEach((doc) {
                Product product = Product.fromDocument(doc);
                ProductResult searchResult = ProductResult(product);
                searchResults.add(searchResult);
              });
              return ListView(children: searchResults);
              }
            );
          }
        
          @override
          Widget build(BuildContext context) {
            return Container(
              margin: EdgeInsets.all(kDefaultPadding),
              padding: EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kDefaultPadding / 4, // 5 top and bottom
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        }
        
class ProductResult extends StatelessWidget {
  final Product product;

  ProductResult(this.product);

  showProductDescription(BuildContext context, {String productId}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(product: product,)));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}
