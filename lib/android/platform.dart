import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class AndroidMethods {
  static const platform = const MethodChannel('org.ikol.public_app/share');

  static Future<bool> shouldShowRequestPermissionRationale() async {
    try {
      var result =
          await platform.invokeMethod("shouldShowRequestPermissionRationale");
      return (result as bool);
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> checkLocationPermissions() async {
    try {
      await platform.invokeMethod("checkLocationPermissions");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  static Future<bool> isLocationEnabled() async {
    try {
      var result = await platform.invokeMethod("isLocationEnabled");
      return (result as bool);
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> startSharing(String id) async {
    try {
      await platform.invokeMethod("startSharing", id);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  static Future<void> stopSharing(String id) async {
    try {
      await platform.invokeMethod("stopSharing", id);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  static Future<Position> getUserLocation() async {
    final geoPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    print(geoPosition.latitude);
    print(geoPosition.longitude);
    return geoPosition;
  }
}
