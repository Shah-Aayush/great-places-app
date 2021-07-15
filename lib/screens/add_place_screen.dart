import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/image_input.dart';
import '../widgets/location_input.dart';
import '../providers/great_places.dart';
import '../models/place_location.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';
  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  // final _titleController = TextEditingController();
  File? _pickedImage;
  var placeTitle;
  var imageInputColor = Colors.blue;
  var locationInputColor = Colors.blue;
  PlaceLocation? _pickedLocation;

  void _selectImage(File? pickedImage, bool response) {
    if (response == false) {
      setState(() {
        imageInputColor = Colors.red;
      });
      return;
    } else {
      setState(() {
        imageInputColor = Colors.blue;
      });
    }
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  void _savePlace() {
    final isFormValid = _formKey.currentState!.validate();
    // print('ON SAVE : $isFormValid $placeTitle $_pickedImage');
    var flag1 = true;
    var flag2 = true;
    var flag3 = true;
    if (!isFormValid) {
      print('Please provide a valid title !');
      flag1 = false;
    }
    if (_pickedImage == null) {
      setState(() {
        imageInputColor = Colors.red;
      });
      print('Please pick an image!');
      flag2 = false;
    }
    if (_pickedLocation == null) {
      setState(() {
        locationInputColor = Colors.red;
      });
      print('Please choose location!');
      flag3 = false;
    }
    if (!flag1 || !flag2 || !flag3) {
      return;
    }

    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(placeTitle, _pickedImage!, _pickedLocation!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Place'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter place title';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          placeTitle = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: imageInputColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ImageInput(_selectImage),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: locationInputColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: LocationInput(_selectPlace),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0, //removes default drop shadow.
              tapTargetSize: MaterialTapTargetSize
                  .shrinkWrap, //extra margin around button removed.
              primary: Theme.of(context).colorScheme.secondary,
              // primary: Theme.of(context).accentColor,  //older implementation.
              onPrimary: Colors.black,
            ),
            onPressed: _savePlace,
            icon: Icon(Icons.add),
            label: Text('Add Place'),
          ),
        ],
      ),
    );
  }
}
