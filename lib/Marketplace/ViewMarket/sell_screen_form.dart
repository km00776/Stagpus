// this page will be available for all users.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stagpus/Marketplace/ModelMarket/Product.dart';
import 'package:stagpus/models/user.dart';

class SellScreen extends StatefulWidget {
  final User currentUser;
  final int price;
  final String description;
  final String imageURL; 
  bool isUploading = false;
  Product product;
  File file;
  
  
  SellScreen({Key key, @required this.currentUser, this.price, this.description, this.imageURL}) : super(key: key);

  @override
  _SellScreenState createState() => new _SellScreenState(currentUser);
  
  }
  
class _SellScreenState extends State<SellScreen> {
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

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return  SimpleDialog(
          title: Text("Add product to Market"),
          children: <Widget> [
            SimpleDialogOption(
              child: Text("Photo with Camera"),
              onPressed: handleProductPhoto
            ),
            SimpleDialogOption(
              child: Text("Image from Gallery"),
              onPressed: handleChooseFromGallery(),
            ),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ]
        );
      }
    );
  }


}
