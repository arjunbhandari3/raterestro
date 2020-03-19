import 'package:flutter/material.dart';
import 'package:raterestro/src/pages/CustomSearch.dart';
import 'package:raterestro/src/pages/cart.dart';
import 'package:raterestro/src/pages/login.dart';
import 'package:raterestro/src/pages/loginDashboard.dart';
import 'package:raterestro/src/pages/category.dart';
import 'package:raterestro/src/pages/food.dart';
import 'package:raterestro/src/pages/map.dart';
import 'package:raterestro/src/pages/pages.dart';
import 'package:raterestro/src/pages/mainScreen.dart';
import 'package:raterestro/src/pages/splash.dart';
import 'package:raterestro/src/pages/orderSuccess.dart';
import 'package:raterestro/src/pages/addRestaurant.dart';
import 'package:raterestro/src/pages/addCategory.dart';
import 'package:raterestro/src/pages/addFoodItem.dart';
import 'package:raterestro/src/pages/no_internet.dart';
import 'package:raterestro/src/pages/admin/adminDashboard.dart';
import 'package:raterestro/src/pages/restaurant/restaurantDashboard.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case '/Main':
        return MaterialPageRoute(builder: (_) => Login());
      case '/MainPage':
        return MaterialPageRoute(builder: (_) => MainPage());
      case '/Pages':
        return MaterialPageRoute(
            builder: (_) => PagesListWidget(currentTab: args));
      case '/AdminPages':
        return MaterialPageRoute(
            builder: (_) => AdminPagesListWidget(currentTab: args));
      case '/RestaurantPages':
        return MaterialPageRoute(
            builder: (_) => RestaurantPagesListWidget(currentTab: args)); 
      case '/Map':
        return MaterialPageRoute(builder: (_) => MapWidget());
      case '/category':
        return MaterialPageRoute(builder: (_) => CategoryWidget());
      case '/Food':
        return MaterialPageRoute(builder: (_) => FoodWidget());
      case '/addRestaurant':
        return MaterialPageRoute(builder: (_) => AddRestaurantScreen());
      case '/addCategory':
        return MaterialPageRoute(builder: (_) => AddCategoryScreen());
      case '/addfooditem':
        return MaterialPageRoute(builder: (_) => AddFoodScreen());
      case '/Cart':
        return MaterialPageRoute(builder: (_) => CartWidget());
        case '/orderSuccess':
        return MaterialPageRoute(builder: (_) => OrderSuccessWidget());
      case '/CustomSearch':
        return MaterialPageRoute(builder: (_) => CustomSearch());
      case '/noInternet':
        return MaterialPageRoute(builder: (_) => NoInternetScreen());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => LoginWidget());
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
