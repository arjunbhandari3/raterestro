import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:raterestro/src/services/auth.dart';

final _firebaseMessaging = new FirebaseMessaging();

class Firebasemessaging {
  static String fcmToken = '';

  static Future<Null> init() async {
    print("Firebasemessaging init");

    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));

    fcmToken = await _firebaseMessaging.getToken();
    print("FCM TOKEN : $fcmToken");

    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
      print("FCM TOKEN onTokenRefresh: $fcmToken");
    });

    await updateFCMToken();
  }

  static Future<Null> config() async {
    print("Firebasemessaging Configure");
    _firebaseMessaging.configure(onMessage: (msg) async {
      print('FCM onMessage: ' + msg.toString());
    }, onLaunch: (lun) async {
      print('FCM onLaunch: ' + lun.toString());
    }, onResume: (res) async {
      print('FCM onResume: ' + res.toString());
    });
  }

  static Future<Null> updateFCMToken() async {
    auth.currentUser.fcmToken = fcmToken;
    await setCurrentUser();
  }
}
