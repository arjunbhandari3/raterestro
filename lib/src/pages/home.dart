import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raterestro/src/elements/CardsCarouselWidget.dart';
import 'package:raterestro/src/elements/CategoriesCarouselWidget.dart';
import 'package:raterestro/src/elements/FoodsCarouselWidget.dart';
import 'package:raterestro/src/elements/SearchBarWidget.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  @override
  void initState() {
    super.initState();
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
                'Food Categeries',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF344968),
                ),
              ),
            ),
          ),
          CategoriesCarouselWidget(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              leading: Icon(
                Icons.stars,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                'Nearby Restaurants',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF344968),
                ),
              ),
              subtitle: Text(
                'Ordered by Nearby first',
                style: TextStyle(
                  fontSize: 12.0, 
                  color: Color(0xFF8C98A8),
                ),
              ),
            ),
          ),
          CardsCarouselWidget(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              leading: Icon(
                Icons.stars,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                'Top Restaurants',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF344968),
                ),
              ),
            ),
          ),
          CardsCarouselWidget(),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
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
          ),
          FoodsCarouselWidget(),
        ],
      ),
    );
  }
}
