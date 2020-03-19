import 'package:raterestro/src/models/food_order.dart';
import 'package:raterestro/src/models/order_status.dart';
import 'package:raterestro/src/models/user.dart';
import 'package:raterestro/src/models/payment.dart';

class Order {
  String id;
  String orderStatus;
  String orderDate;
  String orderTime;
  String orderAddress;
  double totalAmount;
  List<FoodOrder> foodOrders;
  // OrderStatus orderStatus;
  User user;
  Payment payment;

  Order();

  Order.fromJSON(Map<dynamic, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    orderStatus = jsonMap['orderStatus'];
    orderDate = jsonMap['orderDate'];
    orderTime = jsonMap['orderTime'];
    orderAddress = jsonMap['orderAddress'];
    totalAmount = jsonMap['totalAmount'].toDouble();
    // orderStatus = jsonMap['order_status'] != null ? OrderStatus.fromJSON(jsonMap['order_status']) : new OrderStatus();
    user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : new User();
    foodOrders = jsonMap['foodOrders'] != null
        ? List.from(jsonMap['foodOrders']).map((element) => FoodOrder.fromJSON(element)).toList()
        : [];
  }

  Map toMap() {
    var map = new Map<dynamic, dynamic>();
    map["id"] = id;
    map["user_id"] = user?.id;
    // map["order_status_id"] = orderStatus?.id;
    map["orderStatus"] = orderStatus;
    map["foods"] = foodOrders.map((element) => element.toMap()).toList();
    map["payment"] = payment.toMap();
    return map;
  }
}