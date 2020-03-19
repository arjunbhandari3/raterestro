import 'package:flutter/material.dart';
import 'package:raterestro/src/models/food.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/pages/food.dart';

class FoodGridItemWidget extends StatelessWidget {
  final Food food;
  final String foodID;

  FoodGridItemWidget({Key key, this.food, this.foodID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => FoodWidget(food:food),
          ),
        );
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(this.food.image), fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                food.name,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  fontSize: 12.0, 
                  color:Color(0xFF344968),
                ),
              ),
              SizedBox(height: 2),
              Text(
                Helper.getPrice(food.price),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1DBF73),
                ),
              ),
              SizedBox(height: 2),
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
        ],
      ),
    );
  }
}
