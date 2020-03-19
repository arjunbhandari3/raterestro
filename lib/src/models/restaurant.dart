import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/models/food.dart';
import 'package:raterestro/src/models/review.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Restaurant {
  String id;
  String name;
  String image;
  String rate;
  String address;
  String description;
  String phone;
  String mobile;
  String information;
  GeoPoint position;
  double distance;
  List<Food> restaurantFoods;
  List<Review> restaurantReviews;

  Restaurant({
    this.id,
    this.name,
    this.image,
    this.rate,
    this.address,
    this.description,
    this.phone,
    this.mobile,
    this.information,
    this.position,
    this.restaurantFoods,
    this.restaurantReviews,
  });
  Restaurant.fromJSON(Map<dynamic, dynamic> jsonMap){
    id = jsonMap['id'];
    name = jsonMap['name'];
    image = jsonMap['image'];
    rate = jsonMap['rate'] ?? '0';
    address = jsonMap['address'];
    description = jsonMap['description'];
    phone = jsonMap['phone'];
    mobile = jsonMap['mobile'];
    information = jsonMap['information'];
    position= jsonMap['position']['geopoint'];
    distance = jsonMap['distance'] != null ? double.parse(jsonMap['distance'].toString()) : 0.0;
    restaurantReviews = jsonMap['restaurant_reviews'] != null 
      ? List.from(jsonMap['restaurant_reviews'])
        .map((element) => Review.fromJSON(element))
        .toList()
      : null;
    restaurantFoods = jsonMap['restaurant_foods'] != null 
      ? List.from(jsonMap['restaurant_foods'])
        .map((element) => Food.fromJSON(element))
        .toList()
      : null;  
  }
  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position':position,
      'distance': distance,
    };
  }
}
