import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/great_places.dart';
import './screens/places_list_screen.dart';
import './screens/add_place_screen.dart';
import './screens/place_detail_screen.dart';
import './helpers/get_current_loc.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child: MultiProvider(
providers: [
        Provider<GetCurrentLoc>(create: (_) => GetCurrentLoc())
      ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Great Places',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            colorScheme:
                Theme.of(context).colorScheme.copyWith(secondary: Colors.amber),
          ),
          home: const PlacesListScreen(),
          routes: {
            AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
            PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
          },
        ),
      ),
    );
  }
}


/*
  keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
  keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
*/