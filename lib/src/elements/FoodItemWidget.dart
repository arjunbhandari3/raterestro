import 'package:flutter/material.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/food.dart';
import 'package:raterestro/src/models/restaurant.dart';
import 'package:raterestro/src/pages/food.dart';

class FoodItemWidget extends StatelessWidget {
  final String foodID;
  Food food;

  FoodItemWidget({Key key,this.foodID, this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => FoodWidget(food:food,foodID:foodID),
          ),
        );
      },
      child: Container(
        // height: 80,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(image: NetworkImage(food.image), fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          food.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color:Color(0xFF344968),
                          ),
                        ),
                        Text(
                          food.restaurantName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 12.0, 
                            color: Color(0xFF8C98A8),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: Helper.getStarsList(double.parse(food.rate)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    Helper.getPrice(food.price), 
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF344968),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
