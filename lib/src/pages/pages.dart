import 'package:flutter/material.dart';
import 'package:raterestro/src/elements/DrawerWidget.dart';
import 'package:raterestro/src/elements/ShoppingCartButtonWidget.dart';
import 'package:raterestro/src/pages/home.dart';
import 'package:raterestro/src/pages/orders.dart';
import 'package:raterestro/src/pages/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raterestro/src/pages/search.dart';

class PagesListWidget extends StatefulWidget {
  int currentTab;
  String currentTitle = 'Home';
  Widget currentPage = HomeWidget();

  PagesListWidget({
    Key key,
    this.currentTab,
  }) {
    currentTab = currentTab != null ? currentTab : 0;
  }

  @override
  _PagesListWidgetState createState() {
    return _PagesListWidgetState();
  }
}

class _PagesListWidgetState extends State<PagesListWidget> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesListWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentTitle = 'Home';
          widget.currentPage = HomeWidget();
          break;
        case 1:
          widget.currentTitle = 'Search';
          widget.currentPage = SearchPageWidget();
          break;
        case 2:
          widget.currentTitle = 'My Orders';
          widget.currentPage = OrdersWidget();
          break;
        case 3:
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
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
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
            icon: Icon(Icons.home),
            title: Text(
              "Home",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(
              "Search",
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.fastfood),
            title: Text(
              "My Orders",
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
