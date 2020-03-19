import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raterestro/src/elements/BlockButtonWidget.dart';
import 'package:raterestro/src/pages/pages.dart';
import 'package:raterestro/src/pages/completeProfile.dart';
import 'package:raterestro/src/models/user.dart';
import 'package:raterestro/src/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raterestro/src/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:raterestro/src/services/app_notifications.dart';

class LoginWidget extends StatefulWidget {
  _LoginWidgeState createState() => new _LoginWidgeState();
}

enum ConfirmAction { CANCEL, ACCEPT }

class _LoginWidgeState extends State<LoginWidget> {
  
  String _verificationId = "";
  int _currentPage = 0;
  PageController _pageController;
  bool loading = true;
  Timer _timer;
  int _start = 60;
  bool _isTextVisible = false;
  bool _resendOTP = false;
  bool _processing = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _numberFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  void _startTimer() {
    const sec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      sec,
      (Timer timer) => setState(() {
        _isTextVisible = true;
        if (_start < 1) {
          _timer.cancel();
          _isTextVisible = false;
          _resendOTP = true;
        } else {
          _start = _start - 1;
        }
      }),
    );
  }

  @override
  void initState() {
    bool loading = true;
    super.initState();
    _pageController = new PageController();
  }
  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  Widget loginWidget() {
    return Form(
      key: _numberFormKey,
      child: ListView(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text(
                  "Welcome",
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
                  "Let’s start with Login. Please enter your mobile number",
                  style: TextStyle(fontSize: 20.0, color: Color(0xFF344968)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: TextField(
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF1DBF73),
                  ),
                  maxLength: 10,
                  inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp("[0-9]"))],
                  enableInteractiveSelection: false,
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF1DBF73), width: 2.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF1DBF73),),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintText: "Enter mobile number",
                    hintStyle: new TextStyle(
                      color: Colors.grey,
                      fontSize:20,
                    ),
                    labelText: 'MOBILE NUMBER',
                    labelStyle: new TextStyle(
                      color: Colors.black,
                      fontSize:20,
                    ),
                    prefixIcon: const Icon(
                      Icons.phone_android,
                      color: Colors.black,
                    ),
                    prefixText: ' +977 ',
                    prefixStyle: new TextStyle(
                      color: Colors.black,
                      fontSize:20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          _isTextVisible
            ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'You will recieve an OTP within $_start seconds for verification.',
                style: TextStyle(
                  fontSize: 14.0, 
                  color: Color(0xFF344968),
                ),
              ),
            )
            : (_resendOTP)
              ? Padding(
                padding: EdgeInsets.all(10.0),
                child: Wrap(
                  children: <Widget>[
                    Text(
                      'Did you enter correct details?',
                      style: TextStyle(
                        fontSize: 14.0, 
                        color: Color(0xFF344968),
                      ),
                    ),
                  ],
                ),
              )
              : SizedBox(height: 0.1),
          SizedBox(height: 60),
          !_processing
          ? !(_resendOTP)
            ? new BlockButtonWidget(
              onPressed: () {
                if (phoneController.text.length == 10) {
                  _asyncConfirmDialog(context);
                }
                if (phoneController.text.length == 0) {
                  var snackBar = SnackBar(content: Text(
                      "* Mobile Number is required."));
                  scaffoldKey.currentState.showSnackBar(snackBar);
                }
                if (phoneController.text.length > 0 && phoneController.text.length < 10) {
                  var snackBar = SnackBar(content: Text(
                      "Invaild Mobile number. Please enter a valid Mobile number."));
                  scaffoldKey.currentState.showSnackBar(snackBar);
                }
              },
              color: Theme.of(context).accentColor,
              text: Text(
                'SEND OTP',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
            : BlockButtonWidget(
              onPressed: () {
                setState(() {
                  _processing = true;
                });
                verifyPhoneNumber();
              },
              color: Theme.of(context).accentColor,
              text: Text(
                'RESEND OTP',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : FlatButton(
            onPressed: () {},
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            color: Theme.of(context).accentColor.withOpacity(1),
            shape: StadiumBorder(),
            child: CircularProgressIndicator(backgroundColor: Colors.white),
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login With Phone'),
          content: Text(
              'Do you want to send OTP on ' + '+977'+ phoneController.text + " ?"),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () async {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
                _startTimer();
                setState(() {
                  _processing = true;
                });
                verifyPhoneNumber();
              },
            )
          ],
        );
      },
    );
  }

  Widget otpWidget() {
    return Form(
      key: _otpFormKey,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 50),
          SizedBox(
            width: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Text(
                  'Verify Your Number',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1DBF73),
                    letterSpacing: 0.88,
                    inherit: false,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Text(
                  'We are sending OTP to validate your mobile number.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF344968),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: TextField(
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xFF1DBF73),
                  ),
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp("[0-9]"))],
                  enableInteractiveSelection: false,
                  keyboardType: TextInputType.number,
                  controller: otpController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2), width: 2.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintText: "000000",
                    hintStyle: new TextStyle(
                      color: Colors.grey,
                      fontSize:25,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            'OTP has been sent to +977 '+ phoneController.text,
            style: TextStyle(
              fontSize: 14.0, 
              color: Color(0xFF344968),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 80),
          !_processing
          ? BlockButtonWidget(
            onPressed: () {
              setState(() {
                _processing = true;
              });
              if (otpController.text.length == 6) {
                loading
                  ? scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Row(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Authenticating, Please wait ...'),
                      ],
                    ),
                  ))
                  : Container();
                _signInWithPhoneNumber();
              }
              else if (otpController.text.length == 0) {
                setState(() {
                  _processing = false;
                });
                var snackBar = SnackBar(content: Text(
                    "* OTP cannot be NULL."));
                scaffoldKey.currentState.showSnackBar(snackBar);
              }
              else if(otpController.text.length > 0 && otpController.text.length < 6 ){
                setState(() {
                  _processing = false;
                });
                var snackBar = SnackBar(content: Text(
                    "Invalid OTP. Please enter the valid OTP."));
                scaffoldKey.currentState.showSnackBar(snackBar);
              }
            },
            color: Theme.of(context).accentColor,
            text: Text(
              'Verify'.toUpperCase(),
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
          : FlatButton(
            onPressed: () {},
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            color: Theme.of(context).accentColor.withOpacity(1),
            shape: StadiumBorder(),
            child: CircularProgressIndicator(backgroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
  updateCurrentPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  gotoPage(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 700), curve: Curves.easeIn);
  }
  
  void verifyPhoneNumber() async {
    try {
      final PhoneVerificationCompleted verificationCompleted = (AuthCredential userCreds) async{
        print('signInWithPhoneNumber auto succeeded: $userCreds');
        final AuthResult result =
            await FirebaseAuth.instance.signInWithCredential(userCreds);
        if (result.user != null) {
          // Handle logged in state
          await Firestore.instance
          .collection('users')
          .document(result.user.uid)
          .get()
          .then((DocumentSnapshot ds) async{
            if (ds.exists && ds.data["role"] == 'user' && ds.data["name"] != null && ds.data['address'] != null) {
              auth.currentUser = User(
                loggedIn: true,
                id: result.user.uid,
                name: ds.data["name"],
                address: ds.data["address"],
                phone: '+977' + phoneController.text,
                email: ds.data['email'],
                fcmToken: Firebasemessaging.fcmToken,
                image: ds.data['image'],
                role: 'user',
                coin: ds.data['coin'],
              );
              print(auth.currentUser);
              await setCurrentUser();
              await updateUser().then((value) {
                Navigator.of(context).popUntil((predicate) => predicate.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PagesListWidget(),
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
                setState(() {
                  _processing = false;
                  loading = false;
                });
              });
            } else {
              auth.currentUser = User(
                loggedIn: false,
                id: result.user.uid,
                name: "",
                address: "",
                phone: '+977' + phoneController.text,
                email: "",
                fcmToken: Firebasemessaging.fcmToken,
                image: "",
                role: 'user',
                coin: 0,
              );
              setCurrentUser();
              await updateUser().then((value) {
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Welcome, Now Complete your Profile Details'),
                ));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> CompleteProfile()));
                setState(() {
                  _processing = false;
                  loading = false;
                });
              });
            }
          });
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Something Went Wrong. Try Again Later"),
          ));
          setState(() {
            _processing = false;
          });
        }
      };

      final PhoneVerificationFailed verificationFailed = (AuthException authException) {
        print(
            'Phone number verification failed. Code: ${authException
                .code}. Message: ${authException.message}');
        var snackBar = SnackBar(content: Text(
            "Cannot send OTP. Please enter your Internet Connection."));
        scaffoldKey.currentState.showSnackBar(snackBar);
      };

      final PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
        print('Please check your phone for the verification code.');
        _timer.cancel();
        setState(() {
          _processing = false;
          _isTextVisible = false;
        });
        _verificationId = verificationId;
        gotoPage(1);
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
        _verificationId = verificationId;
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+977" + phoneController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      print(e.message);
    }
  }

  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: otpController.text
    );
    FirebaseAuth.instance.signInWithCredential(credential).then((AuthResult result) async{
      if (result.user != null) {
        // Handle logged in state   
        await Firestore.instance
          .collection('users')
          .document(result.user.uid)
          .get()
          .then((DocumentSnapshot ds) async{
            if (ds.exists && ds.data["role"] == 'user' && ds.data["name"] != null && ds.data['address'] != null) {
              auth.currentUser = User(
                loggedIn: true,
                id: result.user.uid,
                name: ds.data["name"],
                address: ds.data["address"],
                phone: '+977' + phoneController.text,
                email: ds.data['email'],
                fcmToken: Firebasemessaging.fcmToken,
                image: ds.data['image'],
                role: 'user',
                coin: ds.data['coin'],
              );
              await setCurrentUser();
              await updateUser().then((value) {
                Navigator.of(context).popUntil((predicate) => predicate.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PagesListWidget(),
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
                setState(() {
                  _processing = false;
                  loading = false;
                });
              });
            } else {
              auth.currentUser = User(
                loggedIn: false,
                id: result.user.uid,
                name: "",
                address: "",
                phone: '+977' + phoneController.text,
                email: "",
                fcmToken: Firebasemessaging.fcmToken,
                image: "",
                role: 'user',
                coin: 0,
              );
              setCurrentUser();
              await updateUser().then((value) {
                setState(() {
                  _processing = false;
                  loading = false;
                });
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Welcome, Now Complete your Profile Details'),
                ));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> CompleteProfile()));
                setState(() {
                  _processing = false;
                  loading = false;
                });
              });
            }
          });
      } else {
        setState(() {
          _processing = false;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Error validating OTP, try again"),
        ));
      }
    }).catchError((error) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(error),
      ));
      setState(() {
        _processing = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Stack(
          children: <Widget>[
            PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: updateCurrentPage,
              children: <Widget>[
                loginWidget(),
                otpWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}