import 'package:flutter/material.dart';
import 'package:raterestro/src/pages/restaurant/DrawerWidget.dart';
import 'package:raterestro/src/elements/ShoppingCartButtonWidget.dart';
import 'package:raterestro/src/pages/home.dart';
import 'package:raterestro/src/pages/restaurant/orders.dart';
import 'package:raterestro/src/pages/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raterestro/src/pages/search.dart';

class RestaurantPagesListWidget extends StatefulWidget {
  int currentTab;
  String currentTitle = 'My Orders';
  Widget currentPage = OrdersWidget();

  RestaurantPagesListWidget({
    Key key,
    this.currentTab,
  }) {
    currentTab = currentTab != null ? currentTab : 0;
  }

  @override
  _RestaurantPagesListWidgetState createState() {
    return _RestaurantPagesListWidgetState();
  }
}

class _RestaurantPagesListWidgetState extends State<RestaurantPagesListWidget> {
  initState() {
    super.initState();
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentTitle = 'View Orders';
          widget.currentPage = OrdersWidget();
          break;
        case 1:
          widget.currentTitle = 'Search';
          widget.currentPage = SearchPageWidget();
          break;
        case 2:
          widget.currentTitle = 'Profile';
          widget.currentPage = ProfileWidget();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.currentTitle,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1DBF73),
            letterSpacing: 1.3,
          ),
        ),
      ),
      body: widget.currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).accentColor,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        iconSize: 22,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
        currentIndex: widget.currentTab,
        onTap: (int i) {
          this._selectTab(i);
        },
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.fastfood),
            title: Text(
              "My Orders",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(
              "Search",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(
              "Account",
            ),
          ),
        ],
      ),
    );
  }
}
