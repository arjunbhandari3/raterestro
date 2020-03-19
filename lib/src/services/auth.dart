import 'package:firebase_auth/firebase_auth.dart';
import 'package:raterestro/src/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final auth = new Auth();
Future<SharedPreferences> sharedPreferencesObject = SharedPreferences.getInstance();

class Auth {
  User currentUser;
}

Future<Null> getCurrentUser() async {
  final SharedPreferences prefs = await sharedPreferencesObject;
  
  print("getCurrentUser");

  User user = new User(
    id: prefs.getString('id') ?? "",
    loggedIn: prefs.getBool('loggedIn') ?? false,
    name: prefs.getString('name') ?? "",
    address: prefs.getString('address') ?? "",
    phone: prefs.getString('phone') ?? "",
    email: prefs.getString('email') ?? "",
    fcmToken: prefs.getString('fcmToken') ?? "",
    image: prefs.getString('image') ?? "",
    role: prefs.getString('role') ?? "",
    coin: prefs.getInt('coin'),
  );

  auth.currentUser = user;

  logUser();
}

Future<Null> setCurrentUser() async {
  print("setCurrentUser");

  final SharedPreferences prefs = await sharedPreferencesObject;

  prefs.setBool('loggedIn', auth.currentUser.loggedIn ?? false);
  prefs.setString('id', auth.currentUser.id);
  prefs.setString('name', auth.currentUser.name);
  prefs.setString('address', auth.currentUser.address);
  prefs.setString('phone', auth.currentUser.phone);
  prefs.setString('email', auth.currentUser.email);
  prefs.setString('fcmToken', auth.currentUser.fcmToken);
  prefs.setString('image', auth.currentUser.image);
  prefs.setString('role', auth.currentUser.role);
  prefs.setInt('coin', auth.currentUser.coin);
  logUser();
}

logUser() {
  print('''
  ===========Current User=========
  ID:${auth.currentUser.id}
  Name:${auth.currentUser.name}
  Address:${auth.currentUser.address}
  Image:${auth.currentUser.image}
  phone:${auth.currentUser.phone}
  Email:${auth.currentUser.email}
  role:${auth.currentUser.role}
  coin:${auth.currentUser.coin}
  fcmToken:${auth.currentUser.fcmToken}
  
  ''');
}

Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('id');
  await prefs.remove('loggedIn');
  await prefs.remove('name');
  await prefs.remove('phone');
  await prefs.remove('email');
  await prefs.remove('address');
  await prefs.remove('image');
  await prefs.remove('fcmToken');
  await prefs.remove('role');
  await prefs.remove('coin');
}
