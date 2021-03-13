import 'dart:convert';

import 'package:http/http.dart' as http;

const String BaseURL = 'http://192.168.0.101:3000';

class APIMethods {
  static Future<void> toggleActive(bool active) async {
    const url = '/public_users/user/604a724263d642654fd8b333/actions/active';
    await http.post(
      Uri.parse("$BaseURL/$url"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({'active': active}),
    );
  }
}
