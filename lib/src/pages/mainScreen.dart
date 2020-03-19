import 'package:flutter/material.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            body: Stack(
                children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                Text(
                                    'Welcome! To',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor,
                                    ),
                                ),
                                new Padding(padding: const EdgeInsets.only(top: 20.0)),
                                Image.asset("assets/title_icon.jpg", height: 150),
                                new Padding(padding: const EdgeInsets.only(top: 20.0)),
                                Text(
                                    'RateRestro',
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).accentColor,
                                    ),
                                ),
                                SizedBox(height:40),
                                SizedBox(
                                    child: Text(
                                        'Login As',
                                        style: TextStyle(fontSize: 20, color: Colors.black),
                                        textAlign: TextAlign.left,
                                    ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 32, bottom: 16),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(Radius.circular(25)),
                                    ),
                                    width: 250,
                                    child: FlatButton(
                                        child: Text(
                                            'USER',
                                            style: TextStyle(fontSize: 20, color: Colors.white),
                                        ),
                                        onPressed: () {
                                            Navigator.of(context).popUntil((predicate) => predicate.isFirst);
                                            Navigator.of(context).pushReplacementNamed('/Login');
                                        },
                                    ),
                                ),
                                SizedBox(
                                    child: Text(
                                        'OR',
                                        style: TextStyle(fontSize: 20, color: Colors.black),
                                        textAlign: TextAlign.left,
                                    ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 10, bottom: 16),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Theme.of(context).accentColor,),
                                        borderRadius: BorderRadius.all(Radius.circular(25)),
                                    ),
                                    width: 250,
                                    child: FlatButton(
                                        child: Text(
                                            'RESTAURANT',
                                            style: TextStyle(fontSize: 20, color: Theme.of(context).accentColor),
                                        ),
                                        onPressed: () {
                                            Navigator.of(context).popUntil((predicate) => predicate.isFirst);
                                            Navigator.of(context).pushReplacementNamed('/Main');
                                        },
                                    ),
                                ),
                                SizedBox(
                                    height: 25,
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        ),
    );
  }
}
