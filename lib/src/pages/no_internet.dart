import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:raterestro/src/services/auth.dart';
import 'package:raterestro/src/pages/pages.dart';

class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {

	Future checkInternet() async {
		var connectivityResult = await (new Connectivity().checkConnectivity());
		if (connectivityResult == ConnectivityResult.none) {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => NoInternetScreen()));
		} else {
			if (auth.currentUser.loggedIn) {
				Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => PagesListWidget()));
			} else {
				Navigator.of(context).pushReplacementNamed('/Login');
			}
		}
	}
  
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () => checkInternet());
  }
   
   bool loading = true;
  
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "No Internet Connection",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1DBF73),
              letterSpacing: 1.3,
            ),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SizedBox(height: 35),
            Container(
              alignment: AlignmentDirectional.center,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                              Colors.green.withOpacity(1),
                              Colors.green.withOpacity(0.2),
                            ])),
                        child: Icon(
                          Icons.report_problem,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 75,
                        ),
                      ),
                      Positioned(
                        right: -30,
                        bottom: -50,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(150),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -20,
                        top: -50,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(150),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Opacity(
                    opacity: 0.4,
                    child: Text(
                      "Please check your internet connection!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF344968),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.all(55),
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
