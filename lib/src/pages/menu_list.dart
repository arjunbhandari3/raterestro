import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/elements/FoodItemWidget.dart';
import 'package:raterestro/src/elements/FoodsCarouselItemWidget.dart';
import 'package:raterestro/src/elements/SearchBarWidget.dart';
import 'package:raterestro/src/elements/ShoppingCartButtonWidget.dart';
import 'package:raterestro/src/models/restaurant.dart';
import 'package:raterestro/src/models/food.dart';
import 'package:raterestro/src/pages/food.dart';
import 'package:raterestro/src/helpers/helper.dart';

class MenuWidget extends StatelessWidget {

  final String restaurantID;
  final Restaurant restaurant;
  MenuWidget({this.restaurant, this.restaurantID});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          restaurant.name,
          overflow: TextOverflow.fade,
          softWrap: false,
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1DBF73),
              letterSpacing: 0,
            ),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(),
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.trending_up,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                'Trending This Week',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF344968),
                ),
              ),
              subtitle: Text(
                'Double click on the food to add it to the cart',
                style: TextStyle(
                  fontSize: 11.0, 
                  color: Color(0xFF8C98A8),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream:Firestore.instance.collection("foodItems").where('restaurantName', isEqualTo: restaurant.name).orderBy("rate", descending: true).snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return new Text('${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularLoadingWidget(height: 150);
                  default:
                    final int count = snapshot.data.documents.length;
                    return count > 0
                      ?  Container(
                        height: 210,
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot document = snapshot.data.documents[index];
                            var data = Food.fromJSON(document.data);
                            final foodID = snapshot.data.documents[index].documentID;
                            double _marginLeft = 0;
                            (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                            return InkWell(
                              splashColor: Theme.of(context).accentColor.withOpacity(0.08),
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => FoodWidget(food:data,foodID:foodID),
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
                                        margin: EdgeInsets.only(left: _marginLeft, right: 20),
                                        width: 150,
                                        height: 130,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(data.image),
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
                                          Helper.getPrice(data.discountPrice),
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
                                      margin: EdgeInsets.only(left: _marginLeft, right: 20),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            data.name,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontSize: 15.0, 
                                              color:Color(0xFF344968),
                                            ),
                                          ),
                                          Text(
                                          Helper.getPrice(data.price),
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontSize: 14.0, 
                                              color:Colors.green,
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                        ))
                        : Container(height:100,child:Center(child:Text('No Items found')));
                  }
                },
              ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.list,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                'All Menu',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF344968),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("foodItems").where('restaurantName', isEqualTo: restaurant.name).orderBy("rate", descending: true).snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return new Text('${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularLoadingWidget(height: 288);
                  default:
                  final int count = snapshot.data.documents.length;
                  return count > 0
                    ?  ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data.documents.length,
                      separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        final DocumentSnapshot document = snapshot.data.documents[index];
                        var data = Food.fromJSON(document.data);
                        final foodID = snapshot.data.documents[index].documentID;
                        return FoodItemWidget(
                          food:data,
                          foodID:foodID,
                        );
                      },
                  )
                  : Container(height:100,child:Center(child:Text('No Items found')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
