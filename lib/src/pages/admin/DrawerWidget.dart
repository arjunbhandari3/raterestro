import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/repository/user_repository.dart';
import 'package:raterestro/src/services/auth.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
 
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/AdminPages', arguments: 2);
            },
            child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance.collection('users').document(auth.currentUser.id).snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) return new Text('${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularLoadingWidget(height: 288);
                  default:
                  var document = snapshot.data;
                  return (document!= null)
                    ?  UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withOpacity(0.1),
                        ),
                        accountName: Text(
                          document["name"],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1DBF73),
                          ),
                        ),
                      
                        accountEmail: Text(
                          document["email"],
                          style: TextStyle(
                            fontSize: 12.0, 
                            color: Color(0xFF8C98A8),
                          ),
                        ),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Theme.of(context).accentColor,
                          backgroundImage: NetworkImage(document["image"]),
                        ),
                      )
                    : CircularLoadingWidget(height: 20);
                  }
                },
              ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/AdminPages', arguments: 0);
            },
            leading: Icon(
              Icons.home,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Home",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color:Color(0xFF344968),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/AdminPages', arguments: 2);
            },
            leading: Icon(
              Icons.person,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Account",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color:Color(0xFF344968),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/addRestaurant');
            },
            leading: Icon(
              Icons.add,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Add Restaurant",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color:Color(0xFF344968),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/addCategory');
            },
            leading: Icon(
              Icons.add,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Add Category",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color:Color(0xFF344968),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              logout().then((value) {
                Navigator.of(context).pushNamed('/MainPage');
              });
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Log out",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color:Color(0xFF344968),
              ),
            ),
          ),
          ListTile(
            dense: true,
            title: Text(
              "Version 0.0.1",
              style: TextStyle(
                fontSize: 12.0, 
                color:Color(0xFF344968),
              ),
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
