import 'dart:io';

import 'package:flutter/material.dart';
import 'package:raterestro/src/elements/ImagePickerAlert.dart';
import 'package:raterestro/src/elements/BlockButtonWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raterestro/src/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raterestro/src/pages/pages.dart';
import 'package:raterestro/src/repository/user_repository.dart';
import 'package:raterestro/src/services/auth.dart';

class CompleteProfile extends StatefulWidget {
  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final _completeProfileFormKey = GlobalKey<FormState>();
  
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = true;
  bool _imagePicked = false;
  File _image;
  String _imageURL = "";
  String _name;
  String _address;
  String _email;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    bool loading = true;
    new Future.delayed(Duration.zero,() {
      Fluttertoast.showToast(
        msg: 'Welcome, Now Complete your Profile Details',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
    super.initState();
  }

  Widget _previewImage() {
    if (_image != null) {
      return Container(
        constraints: BoxConstraints.tightFor(width: 190, height: 190),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            image: FileImage(_image),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints.tightFor(width: 120, height: 120),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: Icon(
        Icons.person,
        size: 120,
        color: Colors.grey[800],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
            child: Form(
              key: _completeProfileFormKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height:40),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 25,
                    ),
                    child: Text(
                      "Complete Your Profile",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Theme.of(context).accentColor,
                      ),
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkResponse(
                            child: Container(
                              child: _previewImage(),
                              constraints: BoxConstraints.tightFor(
                                  width: 200.0, height: 200.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              padding: EdgeInsets.all(8.0),
                            ),
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (context) => ImagePickerAlert(
                                  cameraCallback: () async {
                                    _image = await ImagePicker.pickImage(
                                      source: ImageSource.camera,
                                      maxHeight: 400,
                                      maxWidth: 400,
                                    );
                                    setState(() {
                                      if (_image != null) {
                                        _imagePicked = true;
                                      } else {
                                        _imagePicked = false;
                                      }
                                    });
                                  },
                                  galleryCallback: () async {
                                    _image = await ImagePicker.pickImage(
                                      source: ImageSource.gallery,
                                      maxHeight: 400,
                                      maxWidth: 400,
                                    );
                                    setState(() {
                                      if (_image != null) {
                                        _imagePicked = true;
                                      } else {
                                        _imagePicked = false;
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF1DBF73),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _name = input,
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: new TextStyle(
                          color: Colors.black,
                          fontSize:18,
                        ),
                        contentPadding: EdgeInsets.all(12),
                        hintText: 'John Doe',
                        hintStyle: new TextStyle(
                          color: Colors.grey,
                          fontSize:18,
                        ),
                        prefixIcon: Icon(Icons.person_outline,
                            color: Colors.black),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (input) => _email = input,
                    validator: (input) => !input.contains('@') ? 'Should be a valid email' : null,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).accentColor,
                    ),
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: "Email",
                        contentPadding: EdgeInsets.all(12),
                        labelStyle: new TextStyle(
                          color: Colors.black,
                          fontSize:18,
                        ),
                        hintText: 'johndoe@gmail.com',
                        hintStyle: new TextStyle(
                          color: Colors.grey,
                          fontSize:18,
                        ),
                        prefixIcon: Icon(Icons.alternate_email,
                            color: Colors.black),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF1DBF73),
                      ),
                      keyboardType: TextInputType.text,
                      controller: addressController,
                      onSaved: (input) => _address = input,
                      validator: (input) => input.length < 3
                          ? 'Should be more than 3 letters'
                          : null,
                      decoration: InputDecoration(
                        labelText: "Address",
                        labelStyle: new TextStyle(
                          color: Colors.black,
                          fontSize:18,
                        ),
                        contentPadding: EdgeInsets.all(12),
                        hintText: 'Dhulikhel Kavre',
                        hintStyle: new TextStyle(
                          color: Colors.grey,
                          fontSize:18,
                        ),
                        prefixIcon: Icon(Icons.map,
                            color: Colors.black),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                      ),
                    ),
                  ),
                  SizedBox(height: 80),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: BlockButtonWidget(
                      onPressed: () {
                        if (nameController.text.length == 0 ) {
                          var snackBar = SnackBar(content: Text(
                              "* Your Full Name is required."));
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        }
                        else if (emailController.text.length == 0 ) {
                          var snackBar = SnackBar(content: Text(
                              "* Your Email is required."));
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        }
                        else if (!emailController.text.contains('@') ) {
                          var snackBar = SnackBar(content: Text(
                              "* Your Email is invalid."));
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        }
                        else if (addressController.text.length == 0 ) {
                          var snackBar = SnackBar(content: Text(
                              "* Your Address is required."));
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        }
                        else if (nameController.text.length < 3 && nameController.text.length > 0 || addressController.text.length > 0 &&  addressController.text.length < 3  ) {
                          var snackBar = SnackBar(content: Text(
                              "Should be more than 3 letters"));
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        }
                        else if (!_imagePicked) {
                          var snackBar = SnackBar(
                            content: Text("Please, choose a profie picture."),
                          );
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        }
                        else {
                          loading
                          ? scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Row(
                              children: <Widget>[
                                CircularProgressIndicator(),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Logging in please wait ...'),
                              ],
                            ),
                          ))
                          : Container();
                          
                          submitProfile();
                        }
                      },
                      color: Theme.of(context).accentColor,
                      text: Text(
                        'Submit'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  submitProfile() async {
    try{
      if (_imagePicked) {
        _imageURL = await uploadPhoto(_image,"Users");
        if (_imageURL == null || _imageURL.isEmpty) {
          Navigator.of(context).pop();
          var snackBar = SnackBar(
            content: Text("Something went wrong. Please try again later."),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          return;
        }
      } else {
        var snackBar = SnackBar(
            content: Text("Please, choose a profie picture."),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
      }
      auth.currentUser = User(
        loggedIn: true,
        id: auth.currentUser.id,
        name: nameController.text,
        address: addressController.text,
        phone: auth.currentUser.phone,
        email: emailController.text,
        fcmToken: auth.currentUser.fcmToken,
        image: _imageURL,
        role: 'user',
        coin: auth.currentUser.coin,
      );
      await setCurrentUser();
      await updateUser()
        .then((value) {
          Navigator.of(context).popUntil((predicate) => predicate.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PagesListWidget(),
            ),
          );
          Fluttertoast.showToast(
            msg: 'Welcome' + auth.currentUser.name + ', You are successfully logged in now.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          setState(() {
            loading = false;
          });
        });
    } catch (error){
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Something went Wrong, try again"),
      ));
    }
    
  }
}
