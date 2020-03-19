import 'package:raterestro/src/models/user.dart';

class Review {
  String id;
  String review;
  String rate;
  String userName;
  String userImage;

  Review();

  Review.fromJSON(Map<dynamic, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    review = jsonMap['review'];
    rate = jsonMap['rate'].toString() ?? '0';
    userName = jsonMap['userName'];
    userImage = jsonMap['userImage'];
  }
}
