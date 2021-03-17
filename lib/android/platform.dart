import 'package:flutter/services.dart';

class AndroidMethods {
  static const platform = const MethodChannel('org.ikol.public_app/open');

  static Future<void> openActivity() async {
    try {
      await platform.invokeMethod('openActivity');
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
