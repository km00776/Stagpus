import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String productId;
  String price;
  String productName;
  String description;
  String mediaUrl;

  Product(
      {this.productId,
      this.price,
      this.productName,
      this.description,
      this.mediaUrl});

  factory Product.fromDocument(DocumentSnapshot doc) {
    return Product(
        productId: doc['productId'],
        price: doc['price'],
        productName: doc['productName'],
        description: doc['description'],
        mediaUrl: doc['mediaUrl']);
  }

  Product.fromMap(Map<String, dynamic> map) {
    this.productId = map['productId'];
    this.price = map['price'];
    this.productName = map['name'];
    this.mediaUrl = map['mediaUrl'];
  }

  Map toMap() {
    var map = Map<String, dynamic>();
    map['productId'] = this.productId;
    map['price'] = this.price;
    map['name'] = this.productName;
    map['description'] = this.description;
    map['mediaUrl'] = this.mediaUrl;
    return map;
  }
}

List<Product> products = [
  Product(
    productId: "1",
    price: "56",
    productName: "Classic Leather Arm Chair",
    mediaUrl: "assets/images/Item_1.png",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim",
  ),
  Product(
    productId: "4",
    price: "68",
    productName: "Poppy Plastic Tub Chair",
    mediaUrl: "assets/images/Item_2.png",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim",
  ),
  Product(
    productId: "9",
    price: "39",
    productName: "Bar Stool Chair",
    mediaUrl: "assets/images/Item_3.png",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim",
  ),
];
