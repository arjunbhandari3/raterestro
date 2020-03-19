import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/elements/FoodsCarouselItemWidget.dart';
import 'package:raterestro/src/models/food.dart';

class FoodsCarouselWidget extends StatelessWidget {

  FoodsCarouselWidget({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("foodItems").orderBy("rate", descending: true).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularLoadingWidget(height: 150);
          default:
            return Container(
              height: 220,
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  final foods = snapshot.data.documents[index];
                  var data = Food.fromJSON(foods.data);
                  final foodID = snapshot.data.documents[index].documentID;
                  double _marginLeft = 0;
                  (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                  return FoodsCarouselItemWidget(
                    marginLeft: _marginLeft,
                    food: data,
                    foodID:foodID,
                  );
                },
                scrollDirection: Axis.horizontal,
              ));
          }
        },
      );
  }
}
