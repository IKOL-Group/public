import 'dart:io';
import 'package:dio/dio.dart';
import 'package:public_app/colors/text.dart';
import 'package:public_app/screens/profile/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  Dio dio = new Dio();

  Future<String> userSignUp(email, password, name, phone, employeeId,
      bussinessMan, longitude, latitude) async {
    FormData signUpParams = FormData.fromMap({
      "email": email,
      "password": password,
      "name": name,
      "phone": phone,
      "employee_id": employeeId,
      "business_name": bussinessMan,
      "location": {"longitude": longitude, "latitude": latitude},
      "extras": {"milkman": true, "bellboy": true, "filters": "gt 30"}
    });
    final response = await dio.post(kBaseUrl + "/public_users/actions/create",
        data: signUpParams,
        options:
            Options(headers: {HttpHeaders.acceptHeader: 'application/json'}));
    print("userSignUp:response ${response.statusCode}");
    if (response.statusCode == 200) {
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
    String token = (await SharedPreferences.getInstance()).getString('token');
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

  Future userSetActive(bool value, token) async {
    FormData userActiveParams = FormData.fromMap({"active": value});
    final response = await dio.put(kBaseUrl + "/public_users/actions/password",
        data: userActiveParams,
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

  Future<ProfileModel> getUser() async {
    // /public_users/user/
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    final response = await dio.put("$kBaseUrl/public_users/user/$id",
        options: Options(headers: {
          HttpHeaders.acceptHeader: 'application/json',
        }));

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(response.data);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      return null;
    }
  }
}
