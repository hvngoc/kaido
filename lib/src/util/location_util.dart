import 'package:geolocator/geolocator.dart';

class LocationUtil {
  static getCurrentLocation(
      {required Function(Position) onSuccess,
      required Function(dynamic) onError}) {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.lowest,
            forceAndroidLocationManager: true)
        .then((Position position) {
      onSuccess.call(position);
    }).catchError((e) {
      onError.call(e);
    });
  }

  static getLastKnownPosition(
      {required Function(Position?) onSuccess,
        required Function(dynamic) onError}) {
    Geolocator.getLastKnownPosition()
        .then((Position? position) {
      onSuccess.call(position);
    }).catchError((e) {
      getCurrentLocation(onSuccess: onSuccess, onError: onError);
    });
  }
}
