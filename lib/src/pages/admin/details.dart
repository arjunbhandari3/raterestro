import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raterestro/src/elements/DrawerWidget.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:raterestro/src/models/restaurant.dart';
import 'package:raterestro/src/pages/map.dart';
import 'package:raterestro/src/models/user.dart';
import 'package:raterestro/src/services/auth.dart';
import 'package:raterestro/src/repository/user_repository.dart';
import 'package:raterestro/src/services/app_notifications.dart';

class DetailsWidget extends StatelessWidget {

  final String restaurantID;
  final Restaurant restaurant;
  DetailsWidget({this.restaurant, this.restaurantID});
  
  String email,password;
  bool hidePassword = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _addAdminFormKey = new GlobalKey<FormState>();
 
  _launchCaller() async {
    var url = "tel:${restaurant.phone}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person_add),
                    SizedBox(width: 10),
                    Text(
                      'Add Admin',
                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _addAdminFormKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
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
                        SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => password = input,
                          validator: (input) => input.length < 6 ? 'Should be more than 6 characters' : null,
                          obscureText: true,
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
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      submit();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              SizedBox(height: 10),
            ],
          );
        });
        },
        isExtended: true,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        icon: Icon(Icons.person_add, color: Colors.white),
        label: Text('Add Admin', style: TextStyle(color: Colors.white),),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                expandedHeight: 300,
                elevation: 0,
                pinned: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Hero(
                    tag: restaurant.image,
                    child: Image.network(
                      restaurant.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 10, top: 25),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              restaurant.name,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF344968),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 32,
                            child: Chip(
                              padding: EdgeInsets.all(0),
                              label: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    restaurant.rate,
                                    style: TextStyle(
                                      fontSize: 14.0, 
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star_border,
                                    color: Theme.of(context)
                                        .primaryColor,
                                    size: 16,
                                  ),
                                ],
                              ),
                              backgroundColor: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.9),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Text(
                        restaurant.description,
                        style: TextStyle(
                          fontSize: 14.0, 
                          color:Color(0xFF344968),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.stars,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          'Information',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF344968),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      margin:
                          const EdgeInsets.symmetric(vertical: 5),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        restaurant.information,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14.0, 
                          color: Color(0xFF344968),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.map,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          'Address',
                          style:TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF344968),
                          ),
                        ),
                        trailing: Text(
                          'View Map',
                          style:TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF344968),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      margin:
                          const EdgeInsets.symmetric(vertical: 5),
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              restaurant.address,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 14.0, 
                                color: Color(0xFF344968),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => MapWidget(
                                      currentRestaurant:restaurant,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.directions,
                                color:
                                    Theme.of(context).primaryColor,
                                size: 24,
                              ),
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.9),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.phone,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          'Contact Details',
                          style:TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF344968),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      margin:
                          const EdgeInsets.symmetric(vertical: 5),
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${restaurant.phone} \n${restaurant.mobile}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.0, 
                                color: Color(0xFF344968),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                _launchCaller();
                              },
                              child: Icon(
                                Icons.call,
                                color:
                                    Theme.of(context).primaryColor,
                                size: 24,
                              ),
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.9),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void submit() async {
    if (_addAdminFormKey.currentState.validate()) {
        _addAdminFormKey.currentState.save();
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email,password: password)
        .then((AuthResult result) async {
          if (result.user != null) {
          // Handle logged in state 
          await Firestore.instance
          .collection('users')
          .document(result.user.uid)
          .get()
          .then((DocumentSnapshot ds) async{
            if (!ds.exists) {
              await Firestore.instance
              .collection('users')
              .document(result.user.uid)
              .setData({
                'id': result.user.uid,
                'name': ' ',
                "phone": " ",
                'image': " ",
                "address": " ",
                'email': email,
                'fcmToken': Firebasemessaging.fcmToken,
                'role': 'restaurantAdmin',
              }).then((value) {
                Fluttertoast.showToast(
                  msg: '(' + email+ ') is successfully added as Admin of ${restaurant.name}',
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
                content: Text('User already exists.'),
              ));
            }
          });
          await Firestore.instance
          .collection('admins')
          .document(result.user.uid)
          .get()
          .then((DocumentSnapshot ds) async{
            if (!ds.exists) {
              await Firestore.instance
              .collection('admins')
              .document(result.user.uid)
              .setData({
                'adminID': result.user.uid,
                'email': email,
                'restaurantID': restaurantID,
                'restaurantName': restaurant.name,
              });
            } else {
              scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('User already exists.'),
              ));
            }
          });
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("No Internet Connection. Please check your Internet Connection."),
          ));
        }
        });
    }
  }
}
