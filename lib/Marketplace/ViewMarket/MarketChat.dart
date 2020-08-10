import 'package:flutter/material.dart';
import 'package:stagpus/Chat/ChatView/ChatScreen.dart';
import 'package:stagpus/Marketplace/ModelMarket/Product.dart';
import 'package:stagpus/Marketplace/ViewMarket/MarketColours.dart';
import 'package:stagpus/pages/home.dart';

class ChatAndAddToCart extends StatelessWidget {
  final Product product;
  const ChatAndAddToCart({
    Key key,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(kDefaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFFCBF1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: <Widget>[
          FlatButton(
            child: Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChatScreen(product: product.sellerUsername),
                ),
              );
            },
          ),
          SizedBox(width: kDefaultPadding / 2),
          Text(
            "Chat",
            style: TextStyle(color: Colors.white),
          ),
          // it will cover all available spaces
          Spacer(),
        ],
      ),
    );
  }
}
