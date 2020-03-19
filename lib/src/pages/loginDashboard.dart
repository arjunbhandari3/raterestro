import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raterestro/src/elements/BlockButtonWidget.dart';
import 'package:raterestro/src/pages/pages.dart';
import 'package:raterestro/src/models/user.dart';
import 'package:raterestro/src/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raterestro/src/repository/user_repository.dart';
import 'package:raterestro/src/services/app_notifications.dart';
import 'package:raterestro/src/pages/admin/adminDashboard.dart';
import 'package:raterestro/src/pages/restaurant/restaurantDashboard.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email,password;
  bool hidePassword = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final loginFormKey = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: -150,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white24,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
                children: <Widget>[
                  SizedBox(height:40),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 25,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "RateRestro",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1DBF73),
                              letterSpacing: 0.88,
                              inherit: false,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Let’s start with Login.",
                          style: TextStyle(fontSize: 25.0, color: Color(0xFF344968)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 50,
                              color: Theme.of(context).hintColor.withOpacity(0.2),
                            )
                          ],
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 27),
                      width: MediaQuery.of(context).size.width * 0.88,
                      child: Form(
                        key: loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (input) => email = input,
                              validator: (input) => !input.contains('@') ? 'Should be a valid email' : null,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).accentColor,
                              ),
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.black),
                                contentPadding: EdgeInsets.all(12),
                                hintText: 'johndoe@gmail.com',
                                hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                                prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).accentColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (input) => password = input,
                              validator: (input) => input.length < 6 ? 'Should be more than 6 characters' : null,
                              obscureText: hidePassword,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).accentColor,
                              ),
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.black),
                                contentPadding: EdgeInsets.all(12),
                                hintText: '••••••••••••',
                                hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                                prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                  color: Theme.of(context).focusColor,
                                  icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).accentColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 27),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(top: 25.0),
                            ),
                            GestureDetector(
                                onTap: (){},
                                child: new Text(
                                    "Forgotten Password?",
                                    style: TextStyle(
                                        color: Colors.green,
                                    ),
                                ),
                            ),
                        ],
                    ),
                  ),
                  BlockButtonWidget(
                    text: Text(
                        "LOGIN",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                        login();
                    },
                  ),
                  SizedBox(height: 25),
                ],
              ),
          ),
        ],
      ),
    );
  }
  void login() async {
    if (loginFormKey.currentState.validate()) {
        loginFormKey.currentState.save();
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email,password: password).then((AuthResult result) async{
            if (result.user != null) {
                // Handle logged in state
                await Firestore.instance
                .collection('users')
                .document(result.user.uid)
                .get()
                .then((DocumentSnapshot ds) async{
                    if (ds.exists && ds.data["role"] == 'admin') {
                        auth.currentUser = User(
                            loggedIn: true,
                            id: result.user.uid,
                            name: ds.data["name"],
                            address: ds.data["address"],
                            phone: ds.data["phone"],
                            email: email,
                            fcmToken: Firebasemessaging.fcmToken,
                            image: ds.data['image'],
                            role: 'admin',
                        );
                        print(auth.currentUser);
                        await setCurrentUser();
                        await updateUser().then((value) {
                            Navigator.of(context).popUntil((predicate) => predicate.isFirst);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminPagesListWidget(),
                                ),
                            );
                            Fluttertoast.showToast(
                                msg: 'Welcome ' + ds.data["name"]+ ', You are successfully logged in now.',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                            );
                        });
                    } else if (ds.exists && ds.data["role"] == 'restaurantAdmin'){
                        auth.currentUser = User(
                            loggedIn: true,
                            id: result.user.uid,
                            name: ds.data["name"],
                            address: ds.data["address"],
                            phone: ds.data["phone"],
                            email: email,
                            fcmToken: Firebasemessaging.fcmToken,
                            image: ds.data['image'],
                            role: 'restaurantAdmin',
                        );
                        print(auth.currentUser);
                        await setCurrentUser();
                        await updateUser().then((value) {
                          Navigator.of(context).popUntil((predicate) => predicate.isFirst);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RestaurantPagesListWidget(),
                              ),
                          );
                          Fluttertoast.showToast(
                              msg: 'Welcome ' + ds.data["name"]+ ', You are successfully logged in now.',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                          );
                      });
                    } else {
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("No Internet Connection. Please check your Internet Connection."),
                        ));
                    }
                });
            } else {
                scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Something Went Wrong. Try Again Later"),
                ));
            }
        }).catchError((error) {
            scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Wrong Email or Password'),
            ));
        });
    }
  }
}

