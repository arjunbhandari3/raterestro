import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/elements/ImagePickerAlert.dart';
import 'package:raterestro/src/elements/BlockButtonWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raterestro/src/models/restaurant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raterestro/src/repository/user_repository.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:raterestro/src/services/app_notifications.dart';

class AddRestaurantScreen extends StatefulWidget {
  @override
  _AddRestaurantScreenState createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  final _addRestaurantScreenFormKey = GlobalKey<FormState>();
  
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Geoflutterfire geo = Geoflutterfire();

  bool _imagePicked = false;
  File _image;
  String _imageURL = "";
  String _name;
  String _address;
  String _description;
  String _information;
  String _phone;
  String _mobile;
  String _lat;
  String _lon;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController informationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lonController = TextEditingController();

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
        Icons.restaurant,
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
                'Add Restaurant',
                style:TextStyle(
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
                key: _addRestaurantScreenFormKey,
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
                            hintText: 'Hotel Himalaya',
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
                        controller: descriptionController,
                        onSaved: (input) => _description = input,
                        validator: (input) => input.length < 3
                            ? 'Should be more than 3 letters'
                            : null,
                        decoration: InputDecoration(
                            labelText: "Description",
                            labelStyle: new TextStyle(
                            color: Colors.black,
                            fontSize:18,
                            ),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'Write description about restaurants.',
                            hintStyle: new TextStyle(
                            color: Colors.grey,
                            fontSize:18,
                            ),
                            prefixIcon: Icon(Icons.description,
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
                        controller: informationController,
                        onSaved: (input) => _information = input,
                        validator: (input) => input.length < 3
                            ? 'Should be more than 3 letters'
                            : null,
                        decoration: InputDecoration(
                            labelText: "Information",
                            labelStyle: new TextStyle(
                            color: Colors.black,
                            fontSize:18,
                            ),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'Write information about restaurants.',
                            hintStyle: new TextStyle(
                            color: Colors.grey,
                            fontSize:18,
                            ),
                            prefixIcon: Icon(Icons.info,
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
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        onSaved: (input) => _phone = input,
                        validator: (input) => input.length < 12
                            ? 'Should include country code'
                            : null,
                        decoration: InputDecoration(
                            labelText: "Phone",
                            labelStyle: new TextStyle(
                            color: Colors.black,
                            fontSize:18,
                            ),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'Phone Number',
                            hintStyle: new TextStyle(
                            color: Colors.grey,
                            fontSize:18,
                            ),
                            prefixIcon: Icon(Icons.contact_phone,
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
                        keyboardType: TextInputType.phone,
                        controller: mobileController,
                        onSaved: (input) => _mobile = input,
                        validator: (input) => input.length < 12
                            ? 'Should include country code'
                            : null,
                        decoration: InputDecoration(
                            labelText: "Mobile Number",
                            labelStyle: new TextStyle(
                            color: Colors.black,
                            fontSize:18,
                            ),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'Mobile Number',
                            hintStyle: new TextStyle(
                            color: Colors.grey,
                            fontSize:18,
                            ),
                            prefixIcon: Icon(
                                Icons.phone_android ,
                                color: Colors.black
                            ),
                            prefixText: ' +977 ',
                            prefixStyle: new TextStyle(
                                color: Colors.black,
                                fontSize:18,
                            ),
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
							keyboardType: TextInputType.number,
							controller: latController,
							onSaved: (input) => _lat = input,
							validator: (input) => input.length < 3
								? 'Should include lat'
								: null,
							decoration: InputDecoration(
								labelText: "Latitude",
								labelStyle: new TextStyle(
								color: Colors.black,
								fontSize:18,
								),
								contentPadding: EdgeInsets.all(12),
								hintText: 'Latitude',
								hintStyle: new TextStyle(
								color: Colors.grey,
								fontSize:18,
								),
								prefixIcon: Icon(Icons.pin_drop,
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
							keyboardType: TextInputType.number,
							controller: lonController,
							onSaved: (input) => _lon = input,
							validator: (input) => input.length < 3
								? 'Should include lon'
								: null,
							decoration: InputDecoration(
								labelText: "Longitude",
								labelStyle: new TextStyle(
								color: Colors.black,
								fontSize:18,
								),
								contentPadding: EdgeInsets.all(12),
								hintText: 'Longitude',
								hintStyle: new TextStyle(
								color: Colors.grey,
								fontSize:18,
								),
								prefixIcon: Icon(Icons.pin_drop,
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
                            if (nameController.text.length == 0 || addressController.text.length == 0 || descriptionController.text.length == 0 || informationController.text.length == 0 || phoneController.text.length == 0 || mobileController.text.length == 0 || latController.text.length == 0 || lonController.text.length == 0) {
                                var snackBar = SnackBar(content: Text(
                                    "Enter all field details."));
                                scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                            else if (nameController.text.length < 3 && nameController.text.length > 0 || addressController.text.length > 0 &&  addressController.text.length < 3 || descriptionController.text.length < 3 && descriptionController.text.length > 0 || informationController.text.length > 0 &&  informationController.text.length < 3) {
                            var snackBar = SnackBar(content: Text(
                                "Should be more than 3 letters"));
                            scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                            else if (phoneController.text.length > 0 && phoneController.text.length < 6) {
                                var snackBar = SnackBar(content: Text(
                                    "Invaild Phone number. Please enter a valid Phone number."));
                                scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                            else if (mobileController.text.length > 0 && mobileController.text.length < 10) {
                                var snackBar = SnackBar(content: Text(
                                    "Invaild Mobile number. Please enter a valid Mobile number."));
                                scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                            else if (!_imagePicked) {
                                var snackBar = SnackBar(
                                    content: Text("Please, choose a picture of restaurant."),
                                );
                                scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                            else {
                                submitRestaurant();
                            }
                        },
                        color: Theme.of(context).accentColor,
                        text: Text(
                            'Submit'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color:  Theme.of(context).primaryColor,
                            ),
                        ),
                        ),
                    ),
                    SizedBox(height: 50),
                    ],
                ),
                ),
            ),
            ],
        ),
    );
  }

  submitRestaurant() async {
    if (_imagePicked) {
      _imageURL = await uploadPhoto(_image,"Restaurants");
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
          content: Text("Please, choose a picture of restaurant."),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
    }
    GeoFirePoint point = geo.point(latitude: double.parse(latController.text), longitude: double.parse(lonController.text));
    await Firestore.instance
    .collection('restaurants')
    .add({
      'name': nameController.text,
      'address':addressController.text,
      'image': _imageURL,
      'phone':  phoneController.text,
      'rate': '0',
      'description': descriptionController.text,
      'information': informationController.text,
      'mobile': '+977' + mobileController.text,
      'position': point.data,
      'distance': '0.0'
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
