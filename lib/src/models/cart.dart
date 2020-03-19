import 'package:raterestro/src/models/food.dart';
import 'package:raterestro/src/models/restaurant.dart';

class Cart {
  Food food;
  int quantity;

  Cart(
    this.food,
    this.quantity,
  );

  Cart.fromJSON(Map<dynamic, dynamic> jsonMap) {
    quantity = jsonMap['quantity'];
    food = jsonMap['food'] != null ? Food.fromJSON(jsonMap['food']) : new Food();
    food.price = getFoodPrice();
  }

  Map toMap() {
    var map = new Map<dynamic, dynamic>();
    map["quantity"] = quantity;
    map["food_id"] = food.id;
    return map;
  }

  double getFoodPrice() {
    double result = food.price;
    return result;
  }
}
