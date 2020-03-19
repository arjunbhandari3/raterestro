import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raterestro/src/services/auth.dart';
import 'package:raterestro/src/pages/pages.dart';
import 'package:raterestro/src/pages/admin/adminDashboard.dart';
import 'package:raterestro/src/pages/restaurant/restaurantDashboard.dart';
import 'package:raterestro/src/pages/no_internet.dart';
import 'package:raterestro/src/pages/mainScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
 
  Future checkInternet() async {
    print("checkInternet");
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => NoInternetScreen()));
    } else {
      if (auth.currentUser.loggedIn) {
        if (auth.currentUser.role == 'admin') {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => AdminPagesListWidget()));
        } else if (auth.currentUser.role == 'restaurantAdmin') {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => RestaurantPagesListWidget()));
        } else if (auth.currentUser.role == 'user') {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => PagesListWidget()));
        }
      } else {
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MainPage()));
      }
    }
  }
  
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () => checkInternet());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Center(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("assets/title_icon.jpg", height: 150),
                    new Padding(padding: const EdgeInsets.only(top: 20.0)),
                    new Text(
                      'RateRestro',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height:30),
            Positioned(
              bottom: 50.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: new Container(
                  padding: const EdgeInsets.all(10.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation(Colors.green),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
