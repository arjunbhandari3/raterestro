import 'package:raterestro/src/models/food.dart';

class FoodOrder {
  String id;
  double price;
  int quantity;
  Food food;
  DateTime dateTime;
  FoodOrder();

  FoodOrder.fromJSON(Map<dynamic, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
    quantity = jsonMap['quantity'];
    food = jsonMap['food'] != null ? Food.fromJSON(jsonMap['food']) : [];
  }

  Map toMap() {
    var map = new Map<dynamic, dynamic>();
    map["price"] = price;
    map["quantity"] = quantity;
    map["food"] = food.toMap();
    return map;
  }
}
