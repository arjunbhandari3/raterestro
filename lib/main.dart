import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raterestro/route_generator.dart';
import 'package:raterestro/src/pages/splash.dart';
import 'package:raterestro/src/services/auth.dart';
import 'package:raterestro/src/services/app_notifications.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:raterestro/src/services/cart_services_scoped_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await getCurrentUser();
  await Firebasemessaging.init();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, DeviceOrientation.portraitDown
  ]);
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: CartScopedModel(),
      child: MaterialApp(
        title: 'RateRestro',
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Colors.white,
          brightness: Brightness.light,
          accentColor: Color(0xFF1DBF73),
          focusColor: Color(0xFF8C98A8),
          hintColor: Color(0xFF344968),
        ),
      ),
    );
  }
}
