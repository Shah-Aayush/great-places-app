// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/helpers/get_current_loc.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../helpers/location_helper.dart';
import '../screens/maps_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  LocationInput(this.onSelectPlace);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;
  var messageOnLocationInput = 'Choose a Location for the place!';

  Text getMessage() {
    return Text(
      messageOnLocationInput,
      textAlign: TextAlign.center,
    );
  }

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<LocationData> getCurrentUserLocation() async {
    print('gcul 1');
    Location _userLocation = await Location();
    print('gcul 2');
    LocationData ld = await _userLocation.getLocation();
    print('gcul 3');
    return ld;
  }

  Future<void> _getCurrentUserLocation() async {
    print('getCurrentlocation called.');
    var locData;
    try {
      //1
      // locData = await Location().getLocation().catchError(
      //   (error) {
      //     print('error message from getting location : ${error.toString()}');
      //   },
      // );
      //2
      // locData = await Location().getLocation();
      //3
      locData = await getCurrentUserLocation();

      // if (Platform.isIOS) {
      //   locData =
      //       Provider.of<GetCurrentLoc>(context, listen: false).getLocation();
      // } else {
      //   locData = await Location().getLocation();
      // }

      // final locData = await Location().getLocation();
      print('locData is this :  $locData');
      if (locData.latitude == null) {
        print('null value of latitude!');
        widget.onSelectPlace(locData.latitude, locData.longitude);
        return;
      }
      print('current location : $locData.latitude $locData.longitude');
      _showPreview(
        locData.latitude as double,
        locData.longitude as double,
      );
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      print('error occurred : ${error.toString()}');
      widget.onSelectPlace(locData.latitude, locData.longitude);
      return;
    }
    print('Location fetching method completed.');
  }

  Future<void> _selectOnMap() async {
    final LatLng? selectedLocation = await Navigator.of(context).push(
      // final selectedLocation = await Navigator.of(context).push<LatLng?>(    //this is another approach
      MaterialPageRoute(
        fullscreenDialog:
            true, //shows next screen as a full screen popup where there is a CLOSE BUTTON instead of BACK BUTTON!
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      print('Location is not selected!');
      setState(() {
        messageOnLocationInput = 'No Location chosen.';
      });
      return;
    }
    _showPreview(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<GetCurrentLoc>(context, listen: false).fetchLocation();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          width: MediaQuery.of(context).size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            color: Colors.grey.withOpacity(0.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                icon: Icon(Icons.location_on),
                onPressed: _getCurrentUserLocation,
                label: Text('Current Location'),
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
              ),
              TextButton.icon(
                icon: Icon(Icons.map),
                onPressed: _selectOnMap,
                label: Text('Select on Map'),
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              // border: Border.all(width: 2, color: Colors.blue),
              ),
          child: (_previewImageUrl == null)
              ? getMessage()
              // ? Text(
              //     messageOnImageInput,
              //     textAlign: TextAlign.center,
              //   )
              : Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1, //forcing image to square shape
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          _previewImageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.black.withOpacity(0.1)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        width: 150,
                        child: Text(
                          'on Map',
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ],
                ),
        )
      ],
    );
  }
}


/*
//Older ui : 
Column(
      children: [
        Container(
          height: 170,
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.location_on),
              label: Text('Current location'),
              style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
              style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
            ),
          ],
        )
      ],
    )
*/
/*
AIzaSyCHP0huc8S7iPbMkNEKfOpuZ66iH40b6aY
*/