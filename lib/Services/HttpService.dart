import 'dart:io';
import 'package:dio/dio.dart';
import 'package:public_app/colors/text.dart';
import 'package:public_app/screens/profile/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  Dio dio = new Dio();

  Future<String> userSignUp(email, password, name, phone, employeeId,
      bussinessMan, longitude, latitude) async {
    print("signup");

    final response = await dio.post(kBaseUrl + "/public_users/actions/create",
        data: {
          "email": email,
          "password": password,
          "name": name,
          "phone": phone,
          "employee_id": employeeId,
          "business_name": bussinessMan,
          "location": {"longitude": longitude, "latitude": latitude},
          "extras": {"milkman": true, "bellboy": true, "filters": "gt 30"}
        },
        options:
            Options(headers: {HttpHeaders.acceptHeader: 'application/json'}));
    print("userSignUp:response ${response.statusCode}");
    print("userSignUp:response-data ${response.data}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('id', response.data['details']['id']);
      return "registered";
    } else if (response.statusCode == 401) {
      return "401";
    } else {
      return "error";
    }
  }

  Future<String> userSignIn(phone, password) async {
    final response = await dio.post(kBaseUrl + "/public_users/actions/login",
        data: {"phone": phone, "password": password},
        options:
            Options(headers: {HttpHeaders.acceptHeader: 'application/json'}));
    print("userSignIn:response ${response.statusCode}");
    if (response.statusCode == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('token', response.data['token']);
      return response.data['token'];
    } else if (response.statusCode == 401) {
      return "401";
    } else {
      return "error";
    }
  }

  Future<String> userChangePassword(oldPass, newPass) async {
    /*FormData userPassParams =
        FormData.fromMap({"old": oldPass, "new": newPass});*/
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String token = preferences.getString('token');
    final response = await dio.put(kBaseUrl + "/public_users/actions/password",
        data: {"old": oldPass, "new": newPass},
        options: Options(headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }));
    print("response ${response.data}");
    if (response.statusCode == 200) {
      return "success";
    } else if (response.statusCode == 401) {
      return "401";
    } else {
      return "error";
    }
  }

  Future userLocationUpdate(
      longitude, latitude, userId, bussinessName, token) async {
    FormData userLocationParams = FormData.fromMap({
      "location": {"longitude": longitude, "latitude": latitude},
      "publicUserId": userId,
      "businessName": bussinessName
    });
    final response = await dio.put(kBaseUrl + "/location/public/actions/update",
        data: userLocationParams,
        options: Options(headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      // return result
    } else if (response.statusCode == 401) {
      // return login Page
    } else {
      // return error
    }
  }

  Future userSetActive(bool value) async {
    /*FormData userActiveParams = FormData.fromMap({"active": value});*/
    print("userSetActive");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String loginToken = preferences.getString('token');
    final response = await dio.put(kBaseUrl + "/public_users/actions/password",
        data: {"active": value},
        options: Options(headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $loginToken'
        }));
    if (response.statusCode == 200) {
      // return result
    } else if (response.statusCode == 401) {
      // return login Page
    } else {
      // return error
    }
  }

  Future<ProfileModel> getUser() async {
    print("getUser");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String token = preferences.getString('token');
    final response = await dio.get("$kBaseUrl/public_users/user/$id",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }
        )
    );

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(response.data);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      return null;
    }
  }

  Future<ProfileModel> getUserInfo() async {
    print("getUserInfo");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String token = preferences.getString('token');
    print("id: $id - token:$token");

    final response = await dio.get("$kBaseUrl/public_users/user/$id",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }));

    print("response ${response.data}");
    print("response code ${response.statusCode}");
    switch (response.statusCode) {
      case HttpStatus.ok:
        return ProfileModel.fromJson(response.data);
        //return [true, "", response.data['details']['user']['active'] as bool];
        break;
      case HttpStatus.notFound:
        return null;
        //return [false, "User not Found"];
        break;
      default:
        return null;
        //return [false, "An error occurred on the server"];
    }
  }

  Future<List> toggleActive(bool active) async {
    print("toggleActive");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String token = preferences.getString('token');
    print("id: $id - token:$token");

    final response = await dio.put("$kBaseUrl/public_users/user/$id/actions/active",
        data: {'active': active},
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }));

    print("response ${response.data}");
    print("response code ${response.statusCode}");
    switch (response.statusCode) {
      case HttpStatus.badRequest:
        return [false, "Bad request"];
        break;
      case HttpStatus.ok:
        return [true, "", response.data['details']['active'] as bool];
        break;
      case HttpStatus.notFound:
        return [false, "User not Found"];
        break;
      default:
      // internal server error
        return [false, "An error occurred on the server"];
    }
  }

  Future<bool> logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.clear();

  }
}
