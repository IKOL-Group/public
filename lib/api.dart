import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:public_app/http/code.dart';

const String BaseURL = 'http://192.168.0.101:3000';

class APIMethods {
  static Future<List> toggleActive(bool active) async {
    const route = '/public_users/user/604a724263d642654fd8b333/actions/active';
    var resp = await http.put(
      Uri.parse("$BaseURL$route"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'active': active}),
    );
    // TODO https://github.com/jogboms/flutter_offline
    // TODO https://medium.com/flutter-community/build-a-network-sensitive-ui-in-flutter-using-provider-and-connectivity-ddad140c9ff8
    var data = jsonDecode(resp.body);
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
  }
}
