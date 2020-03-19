import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/elements/ImagePickerAlert.dart';
import 'package:raterestro/src/elements/BlockButtonWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raterestro/src/models/category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raterestro/src/repository/user_repository.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _addCategoryScreenFormKey = GlobalKey<FormState>();
  
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _imagePicked = false;
  File _image;
  String _imageURL = "";
  String _name;

  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Widget _previewImage() {
    if (_image != null) {
      return Container(
        constraints: BoxConstraints.tightFor(width: 190, height: 190),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
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
        shape: BoxShape.rectangle,
        color: Colors.grey[300],
      ),
      child: Icon(
        Icons.fastfood,
        size: 120,
        color: Colors.grey[800],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Add Category',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1DBF73),
              letterSpacing: 1.3,
            ),
          ),
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
                child: Form(
                key: _addCategoryScreenFormKey,
                child: Column(
                    children: <Widget>[
                    SizedBox(height:40),
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
                                    shape: BoxShape.rectangle, color: Colors.white),
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
                            labelText: "Name",
                            labelStyle: new TextStyle(
                            color: Colors.black,
                            fontSize:18,
                            ),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'BreakFast',
                            hintStyle: new TextStyle(
                            color: Colors.grey,
                            fontSize:18,
                            ),
                            prefixIcon: Icon(Icons.restaurant,
                                color: Colors.black),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                        ),
                        ),
                    ),
                    SizedBox(height: 80),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: BlockButtonWidget(
                        onPressed: () {
                            if (nameController.text.length == 0) {
                                var snackBar = SnackBar(content: Text(
                                    "Enter Name Of Category."));
                                scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                            else if (nameController.text.length < 3 && nameController.text.length > 0) {
                            var snackBar = SnackBar(content: Text(
                                "Should be more than 3 letters"));
                            scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                            else if (!_imagePicked) {
                                var snackBar = SnackBar(
                                    content: Text("Please, choose a picture of category."),
                                );
                                scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                            else {
                                submitCategory();
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
            ),
            ],
        ),
    );
  }

  submitCategory() async {
    if (_imagePicked) {
      _imageURL = await uploadPhoto(_image,"Category");
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
          content: Text("Please, choose a picture of category."),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
    }
    await Firestore.instance
    .collection('categories')
    .add({
      'name': nameController.text,
      'image': _imageURL,
    });
    Fluttertoast.showToast(
      msg:  nameController.text + ' is added successfully.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
