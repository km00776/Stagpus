import 'package:flutter/material.dart';

// Data model
// include all the societies for
class Society {
  final String name;
  final String date;
  final String location;
  final String membership;
  final String logo;
  final String time;

  Society(this.name, this.date, this.location, this.membership, this.logo,
      this.time);
}
