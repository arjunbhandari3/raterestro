import 'package:flutter/material.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/restaurant.dart';
import 'package:raterestro/src/pages/map.dart';

class CardWidget extends StatelessWidget {
  Restaurant restaurant;

  CardWidget({Key key,this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 292,
      margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 15, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Image of the card
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(restaurant.image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        restaurant.name,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color:Color(0xFF344968),
                        ),
                      ),
                      Text(
                        restaurant.address,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 12.0, 
                          color: Color(0xFF8C98A8),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: Helper.getStarsList(double.parse(restaurant.rate)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 13),
                 Expanded(
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          print('Go to map');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => MapWidget(currentRestaurant:restaurant),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.directions, 
                          color: Theme.of(context).primaryColor,
                        ),
                        color: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      Text(
                        Helper.getDistance(restaurant.distance),
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
