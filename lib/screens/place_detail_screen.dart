import 'package:flutter/material.dart';
import 'package:great_places/models/place_location.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import './maps_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';
  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final selectedPlace = Provider.of<GreatPlaces>(context, listen: false)
        .findById(id.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: [
          Container(
              height: 250,
              width: double.infinity,
              child: Hero(
                tag: '${id}',
                child: Image.file(
                  selectedPlace.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Text(
            selectedPlace.location!.address as String,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => MapScreen(
                    initialLocation: selectedPlace.location as PlaceLocation,
                    isSelecting: false, //this is default. no need
                  ),
                ),
              );
            },
            child: Text('View on Map'),
            style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
