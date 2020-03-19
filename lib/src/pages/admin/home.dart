import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/restaurant.dart';
import 'package:raterestro/src/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/elements/SearchBarWidget.dart';
import 'package:raterestro/src/pages/admin/details.dart';

class AdminHomeWidget extends StatefulWidget {
  @override
  _AdminHomeWidgetState createState() => _AdminHomeWidgetState();
}

class _AdminHomeWidgetState extends State<AdminHomeWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.run(() {
      // you have a valid context here
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchBarWidget(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              leading: Icon(
                Icons.category,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                'All Categories',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF344968),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("categories").snapshots(),
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
                    var category = Category.fromJSON(document.data);
                    final categoryID = snapshot.data.documents[index].documentID;
                    return Container(
                        // height: 80,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.9),
                            boxShadow: [
                                BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                            ],
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                                Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        image: DecorationImage(image: NetworkImage(category.image), fit: BoxFit.cover),
                                    ),
                                ),
                                SizedBox(width: 25),
                                Flexible(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                            Expanded(
                                                child: Text(
                                                    category.name,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight: FontWeight.w500,
                                                        color:Color(0xFF344968),
                                                    ),
                                                ),
                                            ),
                                            SizedBox(width: 8),
                                        ],
                                    ),
                                ),
                            ],
                        ),
                    );
                },
                )
                : Container(height:100,child:Center(child:Text('No Categories found')));
            }
            },
        ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              leading: Icon(
                Icons.stars,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                'All Restaurants',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF344968),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("restaurants").orderBy("rate", descending: true).snapshots(),
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
                        var restaurant = Restaurant.fromJSON(document.data);
                        final restaurantID = snapshot.data.documents[index].documentID;
                        return InkWell(
                            splashColor: Theme.of(context).accentColor,
                            focusColor: Theme.of(context).accentColor,
                            highlightColor: Theme.of(context).primaryColor,
                            onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => DetailsWidget(restaurant:restaurant,restaurantID:restaurantID),
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
                                        image: DecorationImage(image: NetworkImage(restaurant.image), fit: BoxFit.cover),
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
                                                restaurant.name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w500,
                                                    color:Color(0xFF344968),
                                                ),
                                                ),
                                                Text(
                                                restaurant.address,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
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
                                        SizedBox(width: 8),
                                        ],
                                    ),
                                    )
                                ],
                                ),
                            ),
                        );
                      },
                  )
                  : Container(height:100,child:Center(child:Text('No restaurants found')));
                }
              },
            ),
        ],
      ),
    );
  }
}
