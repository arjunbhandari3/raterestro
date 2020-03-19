import 'package:flutter/material.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/food.dart';
import 'package:raterestro/src/models/restaurant.dart';
import 'package:raterestro/src/pages/food.dart';

class FoodsCarouselItemWidget extends StatelessWidget {
  double marginLeft;
  final String foodID;
  Food food;

  FoodsCarouselItemWidget({Key key, this.marginLeft, this.foodID, this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => FoodWidget(food:food,foodID:foodID),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: this.marginLeft, right: 20),
                width: 140,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(food.image),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 25, top: 5),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)), color: Theme.of(context).accentColor),
                alignment: AlignmentDirectional.topEnd,
                child: Text(
                  Helper.getPrice(food.discountPrice),
                  style: TextStyle(
                    fontSize: 14.0, 
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Container(
              width: 100,
              // height:55,
              margin: EdgeInsets.only(left: this.marginLeft, right: 20),
              child: Column(
                children: <Widget>[
                  Text(
                    food.name,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 12.0, 
                      color:Color(0xFF344968),
                    ),
                  ),
                  Text(
                    Helper.getPrice(food.price),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1DBF73),
                    ),
                  ),
                  Text(
                    food.restaurantName,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 12.0, 
                      color: Color(0xFF8C98A8),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
