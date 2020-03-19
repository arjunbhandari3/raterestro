import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/models/restaurant.dart';
import 'package:raterestro/src/pages/details.dart';
import 'CardWidget.dart';

class CardsCarouselWidget extends StatefulWidget {
  CardsCarouselWidget({Key key}) : super(key: key);

  @override
  _CardsCarouselWidgetState createState() => _CardsCarouselWidgetState();
}

class _CardsCarouselWidgetState extends State<CardsCarouselWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("restaurants").orderBy("distance", descending: false).orderBy("rate", descending: true).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularLoadingWidget(height: 288);
          default:
          final int count = snapshot.data.documents.length;
          return count > 0
            ?  Container(
              height: 288,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: count,
                itemBuilder: (context, index) {
                  final DocumentSnapshot document = snapshot.data.documents[index];
                  var data = Restaurant.fromJSON(document.data);
                  final restaurantID = snapshot.data.documents[index].documentID;
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => DetailsWidget(restaurant:data,restaurantID:restaurantID),
                        ),
                      );
                    },
                    child: CardWidget(restaurant: data),
                  );
                },
              ),
            )
            : Container(height:100,child:Center(child:Text('No Restaurants found')));
          }
        },
      );
  }
}
