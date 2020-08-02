import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/Marketplace/ModelMarket/Product.dart';
import 'package:stagpus/Marketplace/ViewMarket/Details_Screen.dart';
import 'package:stagpus/Marketplace/ViewMarket/MarketColours.dart';
import 'package:stagpus/Marketplace/ViewMarket/category_list.dart';
import 'package:stagpus/Marketplace/ViewMarket/search_market.dart';
import 'package:stagpus/Marketplace/ViewMarket/sell_screen_form.dart';
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
  FirebaseRepository _repository = new FirebaseRepository();
  User currentUser;
  List<Product> p;
  String _currentUserId;
  Product product;

  getProducts() async {
    QuerySnapshot snapshot = await productCollectionRef
        .document(currentUser.uid)
        .collection('userProducts')
        .getDocuments();

    List<Product> products =
        snapshot.documents.map((doc) => Product.fromDocument(doc)).toList();
    setState(() {
      this.p = products;
    });
  }

  Widget productList() {
    return StreamBuilder(
        stream: productCollectionRef
            .document(_currentUserId)
            .collection('userProducts')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return productTest(snapshot.data.documents[index]);
              });
        });
  }

  Widget productTest(DocumentSnapshot snapshot) {
    Product _product = Product.fromMap(snapshot.data);
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
                      itemCount: products.length,
                      itemBuilder: (context, index) => ProductCard(
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
    getProducts();
    _repository.getCurrentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        currentUser = User(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
            photoUrl: user.photoUrl);
      });
    });
  }

  AppBar buildAppBar() {
    return AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text('SurreyMarket'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
            color: Colors.amber[300],
          )
        ]);
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    this.itemIndex,
    this.product,
    this.press,
  }) : super(key: key);

  final int itemIndex;
  final Product product;
  final Function press;

  @override
  Widget build(BuildContext context) {
    // It  will provide us total height and width of our screen
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      height: 160,
      child: InkWell(
        onTap: press,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // Those are our background
            Container(
              height: 136,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: kBlueColor,
                boxShadow: [kDefaultShadow],
              ),
              child: Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            // our product image
            Positioned(
              top: 0,
              right: 0,
              child: Hero(
                tag: product.productId,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  height: 160,
                  // image is square but we add extra 20 + 20 padding thats why width is 200
                  width: 200,
                  //    child: Image.asset(
                  // product.mediaUrl,
                  //fit: BoxFit.cover,
                ),
              ),
            ),
            // ),
            // Product title and price
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: 136,
                // our image take 200 width, thats why we set out total width - 200
                width: size.width - 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Text(
                        "product.toMap().values",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    // it use the available space
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 1.5, // 30 padding
                        vertical: kDefaultPadding / 4, // 5 top and bottom
                      ),
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                      ),
                      child: Text(
                        "product.price,",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
