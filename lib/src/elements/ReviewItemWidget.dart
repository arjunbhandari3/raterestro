import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/review.dart';

// ignore: must_be_immutable
class ReviewItemWidget extends StatelessWidget {
  Review review;

  ReviewItemWidget({Key key, this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Wrap(
        direction: Axis.horizontal,
        runSpacing: 10,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  image: DecorationImage(image: NetworkImage(this.review.userImage), fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            review.userName,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                          child: Chip(
                            padding: EdgeInsets.all(0),
                            label: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  review.rate,
                                  style: TextStyle(
                                    fontSize: 14.0, 
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Icon(
                                  Icons.star_border,
                                  color: Theme.of(context).primaryColor,
                                  size: 16,
                                ),
                              ],
                            ),
                            backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                            shape: StadiumBorder(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Text(
            review.review,
            style: TextStyle(
              fontSize: 14.0, 
              color:Color(0xFF344968),
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 3,
          )
        ],
      ),
    );
  }
}
