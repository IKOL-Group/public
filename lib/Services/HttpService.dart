import 'dart:io';
import 'package:dio/dio.dart';
import 'package:public_app/colors/text.dart';

class HttpService {
  Dio dio = new Dio();
  Future userSignUp(email, password, name, phone, employeeId, bussinessMan,
      longitude, latitude) async {
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
    if (response.statusCode == 200) {
      // return result
    } else if (response.statusCode == 401) {
      // return login Page
    } else {
      // return error
    }
  }

  Future userSignIn(phone, password, token) async {
    FormData signInParams =
        FormData.fromMap({"phone": phone, "password": password});
    final response = await dio.post(kBaseUrl + "/public_users/actions/login",
        data: signInParams,
        options:
            Options(headers: {HttpHeaders.acceptHeader: 'application/json'}));
    if (response.statusCode == 200) {
      // return result
    } else if (response.statusCode == 401) {
      // return login Page
    } else {
      // return error
    }
  }

  Future userChangePassword(oldPass, newPass, token) async {
    FormData userPassParams =
        FormData.fromMap({"old": oldPass, "new": newPass});
    final response = await dio.put(kBaseUrl + "/public_users/actions/password",
        data: userPassParams,
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

  Future userLocationUpdate(longitude, latitude, userId, bussinessName, token) async {
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
}
