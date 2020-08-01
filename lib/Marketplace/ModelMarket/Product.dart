class Product {
  final String productId;
  final String price;
  final String productName;
  final String description;
  final String mediaUrl;

  Product({this.productId, this.price, this.productName, this.description, this.mediaUrl});
}

// list of products
// for our demo (dummy data)
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