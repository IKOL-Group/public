// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    this.action,
    this.details,
    this.error,
    this.message,
  });

  String action;
  Details details;
  String error;
  String message;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    action: json["action"],
    details: Details.fromJson(json["details"]),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "action": action,
    "details": details.toJson(),
    "error": error,
    "message": message,
  };
}

class Details {
  Details({
    this.user,
  });

  User user;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
  };
}

class User {
  User({
    this.id,
    this.active,
    this.businessName,
    this.email,
    this.employeeId,
    this.extradetails,
    this.iconFile,
    this.location,
    this.name,
    this.password,
    this.phone,
  });

  String id;
  bool active;
  String businessName;
  String email;
  String employeeId;
  Extradetails extradetails;
  String iconFile;
  Location location;
  String name;
  String password;
  String phone;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    active: json["active"],
    businessName: json["business_name"],
    email: json["email"],
    employeeId: json["employee_id"],
    extradetails: Extradetails.fromJson(json["extradetails"]),
    iconFile: json["icon_file"],
    location: Location.fromJson(json["location"]),
    name: json["name"],
    password: json["password"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "active": active,
    "business_name": businessName,
    "email": email,
    "employee_id": employeeId,
    "extradetails": extradetails.toJson(),
    "icon_file": iconFile,
    "location": location.toJson(),
    "name": name,
    "password": password,
    "phone": phone,
  };
}

class Extradetails {
  Extradetails({
    this.bellboy,
    this.filters,
    this.milkman,
  });

  bool bellboy;
  String filters;
  bool milkman;

  factory Extradetails.fromJson(Map<String, dynamic> json) => Extradetails(
    bellboy: json["bellboy"],
    filters: json["filters"],
    milkman: json["milkman"],
  );

  Map<String, dynamic> toJson() => {
    "bellboy": bellboy,
    "filters": filters,
    "milkman": milkman,
  };
}

class Location {
  Location({
    this.latitude,
    this.longitude,
  });

  double latitude;
  double longitude;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}
