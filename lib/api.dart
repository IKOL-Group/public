import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:public_app/http/code.dart';

const String BaseURL = 'http://192.168.0.101:3000';

class APIMethods {
  static Future<List> toggleActive(bool active) async {
    const route = '/public_users/user/604a724263d642654fd8b333/actions/active';
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 4);
    final uri = Uri.parse("$BaseURL$route");
    try {
      final body = jsonEncode({'active': active});
      final request = await client.put(uri.host, uri.port, uri.path);
      request.headers.contentType = ContentType.json;
      request.write(body);
      request.headers.contentLength = body.length;

      final resp = await request.close();
      // TODO https://github.com/jogboms/flutter_offline
      // TODO https://medium.com/flutter-community/build-a-network-sensitive-ui-in-flutter-using-provider-and-connectivity-ddad140c9ff8
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
    } on SocketException catch (e) {
      if (e.osError != null) {
        return [false, "You are offline"];
      }
      return [false, "Server could not be reached"];
    }
  }
}
