import 'dart:async';

import 'package:flutter/material.dart';

class EmptyCartWidget extends StatefulWidget {
  EmptyCartWidget({
    Key key,
  }) : super(key: key);

  @override
  _EmptyCartWidgetState createState() => _EmptyCartWidgetState();
}

class _EmptyCartWidgetState extends State<EmptyCartWidget> {
  bool loading = true;

  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? SizedBox(
                height: 3,
                child: LinearProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
                ),
              )
            : SizedBox(),
        Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                          Theme.of(context).focusColor.withOpacity(0.8),
                          Theme.of(context).focusColor.withOpacity(0.3),
                        ])),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 70,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Opacity(
                opacity: 0.4,
                child: Text(
                  "Don't have any item in your cart",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF344968),
                  ),
                ),
              ),
              SizedBox(height: 50),
              !loading
                  ? FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/Pages', arguments: 0);
                      },
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      color: Theme.of(context).accentColor.withOpacity(1),
                      shape: StadiumBorder(),
                      child: Text(
                        'Start Exploring',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
