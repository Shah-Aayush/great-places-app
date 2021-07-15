import 'package:location/location.dart';

class GetCurrentLoc {
  LocationData? _locationData;

  LocationData? getLocation() {
    return _locationData;
  }

  void fetchLocation() {
    Location()
        .getLocation()
        .then((LocationData locationData) => _locationData = locationData);
  }
}
