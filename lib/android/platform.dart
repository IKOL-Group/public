import 'package:flutter/services.dart';

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

  static Future<void> startSharing() async {
    try {
      await platform.invokeMethod("startSharing");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  static Future<void> stopSharing() async {
    try {
      await platform.invokeMethod("stopSharing");
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
