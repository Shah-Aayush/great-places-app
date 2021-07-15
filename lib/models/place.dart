import 'dart:io'; //File datatype includes.

import './place_location.dart';

class Place {
  final String id;
  final String title;
  final PlaceLocation? location;
  final File image;

  Place({
    required this.id,
    required this.image,
    this.location,
    required this.title,
  });
}
