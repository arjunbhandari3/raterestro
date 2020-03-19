import 'package:raterestro/src/models/category.dart';
import 'package:raterestro/src/models/restaurant.dart';
import 'package:raterestro/src/models/review.dart';

class Food {
  String id;
  String name;
  double price;
  double discountPrice;
  String rate;
  String image;
  String description;
  bool featured;
  String restaurantID;
  String categoryName;
  String restaurantName;
  Category category;
  List<Review> foodReviews;

  Food({
    this.id,
    this.name,
    this.image,
    this.rate,
    this.price,
    this.description,
    this.discountPrice,
    this.featured,
    this.categoryName,
    this.restaurantID,
    this.category,
    this.restaurantName,
    this.foodReviews,
  });

  Food.fromJSON(Map<dynamic, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    name = jsonMap['name'];
    price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0;
    discountPrice = jsonMap['discount_price'] != null
        ? jsonMap['discount_price'].toDouble()
        : null;
    rate = jsonMap['rate'] ?? '0';
    description = jsonMap['description'];
    featured = jsonMap['featured'] ?? false;
    categoryName = jsonMap['categoryName'] != null
      ? jsonMap['categoryName']
      : null;
    restaurantID = jsonMap['restaurantID'] != null
      ? jsonMap['restaurantID']
      : null;
    restaurantName = jsonMap['restaurantName'] != null
      ? jsonMap['restaurantName']
      : null;
    image =
        jsonMap['image'];
    foodReviews = jsonMap['food_reviews'] != null
        ? List.from(jsonMap['food_reviews'])
            .map((element) => Review.fromJSON(element))
            .toList()
        : null;
  }

  Map toMap() {
    var map = new Map<dynamic, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["image"]= image;
    map["price"] = price;
    map["featured"] = featured;
    map["rate"]= rate;
    map["discountPrice"] = discountPrice;
    map["description"] = description;
    map["restaurantID"] = restaurantID;
    map["restaurantName"] = restaurantName;
    map["categoryName"] = categoryName;
    return map;
  }
}