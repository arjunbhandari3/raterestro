import 'package:flutter/material.dart';
import 'package:raterestro/src/pages/admin/DrawerWidget.dart';
import 'package:raterestro/src/pages/admin/home.dart';
import 'package:raterestro/src/pages/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raterestro/src/pages/search.dart';

class AdminPagesListWidget extends StatefulWidget {
  int currentTab;
  String currentTitle = 'Home';
  Widget currentPage = AdminHomeWidget();

  AdminPagesListWidget({
    Key key,
    this.currentTab,
  }) {
    currentTab = currentTab != null ? currentTab : 0;
  }

  @override
  _AdminPagesListWidgetState createState() {
    return _AdminPagesListWidgetState();
  }
}

class _AdminPagesListWidgetState extends State<AdminPagesListWidget> {
  initState() {
    super.initState();
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentTitle = 'Home';
          widget.currentPage = AdminHomeWidget();
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
            icon: new Icon(Icons.home),
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
