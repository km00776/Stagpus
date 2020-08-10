import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Marketplace/ModelMarket/Product.dart';
import 'package:stagpus/Marketplace/ViewMarket/Details_Screen.dart';
import 'package:stagpus/Marketplace/ViewMarket/MarketColours.dart';
import 'package:stagpus/pages/home.dart';
import 'package:stagpus/resources/FirebaseRepo.dart';
import 'package:stagpus/widgets/customTile.dart';
import 'package:stagpus/widgets/custom_image.dart';
import 'package:stagpus/widgets/progress.dart';

class SearchMarket extends StatefulWidget {
  List<Product> productList;

  SearchMarket({this.productList});

  @override
  _SearchMarketState createState() => _SearchMarketState();
}

class _SearchMarketState extends State<SearchMarket> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

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
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          icon: Icon(Icons.search),
          hintText: 'Search',
          filled: true,
          hintStyle: TextStyle(color: Colors.white),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewSearch(
                      productList: widget.productList,
                      searchedProductName: searchController.text)));
        },
      ),
    );
  }

  Container buildNoContent() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.greenAccent, Colors.grey])),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text(
              "Find Products",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  handleSearch(String query) {
    Future<QuerySnapshot> products = productCollectionRef
        .where("productName", isEqualTo: query)
        .getDocuments();
    setState(() {
      searchResultsFuture = products;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  buildProductSearchResults() {
    return FutureBuilder(
        future: searchResultsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<ProductResult> searchResults = [];
          snapshot.data.document.forEach((doc) {
            Product product = Product.fromDocument(doc);
            ProductResult searchResult = ProductResult(product);
            searchResults.add(searchResult);
          });
          return ListView(children: searchResults);
        });
  }
}

class ProductResult extends StatelessWidget {
  final Product product;
  ProductResult(this.product);

  showProductDescription(BuildContext context, {String productId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailsScreen(product: product)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.green,
        ),
        child: Column(children: <Widget>[
          GestureDetector(
            onTap: () =>
                showProductDescription(context, productId: product.productId),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
              ),
              title: Text(
                product.productName,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Divider(height: 2.0, color: Colors.white54)
        ]));
  }
}

class NewSearch extends StatefulWidget {
  final String searchedProductName;
  List<Product> productList;

  NewSearch({this.productList, this.searchedProductName});

  @override
  _NewSearchState createState() => _NewSearchState();
}

class _NewSearchState extends State<NewSearch> {
  String query = "";
  TextEditingController searchController = TextEditingController();
  FirebaseRepository _repo = FirebaseRepository();

  buildSuggestions(String query) {
    final List<Product> productSuggestionList = query.isEmpty
        ? []
        : widget.productList != null
            ? widget.productList.where((Product product) {
                String _getProductName = product.productName.toLowerCase();
                String _query = query.toLowerCase();
                bool matchesProductname = _getProductName.contains(_query);

                return matchesProductname;
              }).toList()
            : [];
    return ListView.builder(
        itemCount: productSuggestionList.length,
        itemBuilder: ((context, index) {
          Product searchedProduct = Product(
            productId: productSuggestionList[index].productId,
            productName: productSuggestionList[index].productName,
            sellerUsername: productSuggestionList[index].sellerUsername,
            mediaUrl: productSuggestionList[index].mediaUrl,
            price: productSuggestionList[index].price,
            description: productSuggestionList[index].description,
          );
          return CustomTile(
            mini: false,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                            product: searchedProduct,
                          )));
            },
            leading: CircleAvatar(
                 child: cachedNetworkImage(searchedProduct.mediaUrl),
                ),
            title: Text(
              searchedProduct.productName,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              searchedProduct.price,
              style: TextStyle(color: Colors.green),
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: marketColor,
        appBar: searchAppBar(context),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: buildSuggestions(query),
        ));
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: marketColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.red),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 4,
            ),
            child: TextFormField(
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white),
              ),
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  query = val;
                });
              },
            )),
      ),
    );
  }
}
