import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:public_app/http/code.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors/text.dart';

const String baseURL = 'http://192.168.0.101:3000';
const String userID = '604a724263d642654fd8b333';

class APIMethods {
  /// Returns [success, errorMessage, (optional) result]
  static Future<List> toggleActive(bool active) async {
    const route = '/public_users/user/$userID/actions/active';
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 4);
    final uri = Uri.parse("$baseURL$route");
    try {
      final body = jsonEncode({'active': active});
      final request = await client.put(uri.host, uri.port, uri.path);
      request.headers.contentType = ContentType.json;
      request.headers.contentLength = body.length;
      request.write(body);

      final resp = await request.close();
      // https://stackoverflow.com/a/56964098/8608146
      var data = jsonDecode(await utf8.decoder.bind(resp).join());
      print(data);
      switch (resp.statusCode) {
        case HttpStatus.badRequest:
          return [false, "Bad request"];
          break;
        case HttpStatus.ok:
          return [true, "", data['details']['active'] as bool];
          break;
        case HttpStatus.notFound:
          return [false, "User not Found"];
          break;
        default:
          // internal server error
          return [false, "An error occurred on the server"];
      }
      // https://stackoverflow.com/a/51489701/8608146
    } on TimeoutException catch (e) {
      // TODO this exception is not being thrown when timedout
      print(e);
      // TODO sentry
      return [false, "Unexpected Error occurred, try again"];
    } on SocketException catch (e) {
      if (e.osError != null) {
        // TODO https://github.com/jogboms/flutter_offline
        // TODO https://medium.com/flutter-community/build-a-network-sensitive-ui-in-flutter-using-provider-and-connectivity-ddad140c9ff8
        return [false, "You are offline"];
      }
      return [false, "Server could not be reached"];
    }
  }

  static Future<List> getUserInfo() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    String route = '/public_users/user/$id';
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 4);
    final uri = Uri.parse("$kBaseUrl$route");
    try {
      final request = await client.get(uri.host, uri.port, uri.path);

      final resp = await request.close();
      // https://stackoverflow.com/a/56964098/8608146
      var data = jsonDecode(await utf8.decoder.bind(resp).join());
      print(data);
      switch (resp.statusCode) {
        case HttpStatus.ok:
          return [true, "", data['details']['user']['active'] as bool];
          break;
        case HttpStatus.notFound:
          return [false, "User not Found"];
          break;
        default:
          // internal server error
          return [false, "An error occurred on the server"];
      }
      // https://stackoverflow.com/a/51489701/8608146
    } on TimeoutException catch (e) {
      // TODO this exception is not being thrown when timedout
      print(e);
      // TODO sentry
      return [false, "Unexpected Error occurred, try again"];
    } on SocketException catch (e) {
      if (e.osError != null) {
        // TODO https://github.com/jogboms/flutter_offline
        // TODO https://medium.com/flutter-community/build-a-network-sensitive-ui-in-flutter-using-provider-and-connectivity-ddad140c9ff8
        return [false, "You are offline"];
      }
      return [false, "Server could not be reached"];
    }
  }
}
