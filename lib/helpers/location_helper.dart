import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

const GOOGLE_API_KEY_FOR_IOS = 'AIzaSyAPFnjp5RJx6ICZQwHuP4QZgON27tBCYng';
const GOOGLE_API_KEY_FOR_ANDROID = 'AIzaSyD31Jy3QQ8LjrkKqFnVFwq0Jh6IvoZ9aIE';
// const GOOGLE_API_KEY = 'AIzaSyCHP0huc8S7iPbMkNEKfOpuZ66iH40b6aY';

class LocationHelper {
  static Future<void> checkAPI(String apiKey) async {
    var url = await Uri.parse(apiKey);
    final response = await http.get(url);
    print('recieved response : ${response.body}');
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    print('lat and lng recieved : $lat $lng');
    final url = (Platform.isIOS)
        ? Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY_FOR_IOS')
        : Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY_FOR_ANDROID');
    final response = await http.get(url);
    print('response : ${response.body}');
    print('recieved address : ${json.decode(response.body)['results']}');
    return json.decode(response.body)['results'][0]
        ['formatted_address']; //returning human readable address.
  }

  static String generateLocationPreviewImage({
    required double latitude,
    required double longitude,
  }) {
    // print(
    //     'this is url generated for image :  https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C$latitude,-$longitude&key=$GOOGLE_API_KEY');
    print('fetching..');
    if (Platform.isIOS) {
      print('fetching url for ios platform.');
      var apiKey =
          'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:purple%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY_FOR_IOS';
      checkAPI(apiKey);
      return apiKey;
    } else {
      print('fetching url for android platform.');
      var apiKey =
          'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:purple%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY_FOR_ANDROID';
      checkAPI(apiKey);
      return apiKey;
    }
  }
}
