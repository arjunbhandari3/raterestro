import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class User {
  bool loggedIn;
  String id;
  String name;
  String address;
  String phone;
  String email;
  String fcmToken;
  String image;
  String role;
  int coin;

  User({
    this.loggedIn,
    this.id,
    this.name,
    this.address,
    this.phone,
    this.email,
    this.fcmToken,
    this.image,
    this.role,
    this.coin,
  });

  User.fromJSON(Map<dynamic, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    name = jsonMap['name'];
    fcmToken = jsonMap['fcmtoken'];
    phone = jsonMap['phone'];
    phone = jsonMap['email'];
    address = jsonMap['address'];
    image = jsonMap['image'];
    role = jsonMap['role'];
    coin = jsonMap['coin'];
  }
  
  Map toMap() {
    var map = new Map<dynamic, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["phone"] = phone;
    map["email"] = email;
    map["address"] = address;
    map["image"] = image;
    map["role"] = role;
    map["coin"] = coin;
    return map;
  }
}
