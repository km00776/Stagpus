// this page will be available for all users.
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image/image.dart' as Im;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stagpus/Marketplace/ModelMarket/Product.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/resources/FirebaseMethods.dart';
import 'package:stagpus/resources/FirebaseMethods.dart';
import 'package:stagpus/resources/FirebaseMethods.dart';

class SellScreen extends StatefulWidget {
  final User currentUser;
  final int price;
  final String description;
  final String imageURL;
  bool isUploading = false;
  Product product;
  File file;

  SellScreen(
      {Key key,
      @required this.currentUser,
      this.price,
      this.description,
      this.imageURL})
      : super(key: key);

  @override
  _SellScreenState createState() => new _SellScreenState(currentUser);
}

class _SellScreenState extends State<SellScreen> {
  final FirebaseMethods fbMethods = new FirebaseMethods();
  FirebaseAuth currentUser;
  TextEditingController locationController = TextEditingController();

  _SellScreenState(User currentUser);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  handleProductPhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 400,
    );
    setState(() {
      this.widget.file = file;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.widget.file = file;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(widget.file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$productId.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      widget.file = compressedImageFile;
    });
  }

  addProductToFirestore({String mediaUrl, String location, String description, String price}) async {
     final FirebaseUser user = await FirebaseAuth.instance.currentUser();
     DocumentSnapshot doc = await f

  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
              title: Text("Add product to Market"),
              children: <Widget>[
                SimpleDialogOption(
                    child: Text("Photo with Camera"),
                    onPressed: handleProductPhoto),
                SimpleDialogOption(
                  child: Text("Image from Gallery"),
                  onPressed: handleChooseFromGallery(),
                ),
                SimpleDialogOption(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                )
              ]);
        });
  }

  clearImage() {
    setState(() {
      widget.file = null;
    });
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
  }

  handleSubmission() async {
    setState(() {
      widget.isUploading = false;
    });
    await compressImage();
  }

  Scaffold buildProductForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blueAccent),
          onPressed: clearImage(),
        ),
        title: Text(
          'Caption Post',
        style: TextStyle(
          color: Colors.blueAccent
          ), 
        ),
        actions: [
          FlatButton(
            onPressed: widget.isUploading ? null : () => handleSubmission(),
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0
              )
            )
          )
        ],
      ),
    );
  }
}
