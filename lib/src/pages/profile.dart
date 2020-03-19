import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/services/auth.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return StreamBuilder<DocumentSnapshot>(
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
            ?  Scaffold(
                key: scaffoldKey,
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  width: 135,
                                  height: 135,
                                  child: CircleAvatar(
                                      backgroundImage: NetworkImage(document["image"])),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      auth.currentUser.role == 'user' 
                      ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).hintColor.withOpacity(0.15),
                              offset: Offset(0, 3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: <Widget>[
                            ListTile(
                              onTap: () {},
                              dense: true,
                              title: Text(
                                "Total Coins:",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1DBF73),
                                ),
                              ),
                              trailing: Text(
                                document["coin"].toString(),
                                style: TextStyle(
                                  fontSize: 14.0, 
                                  color: Color(0xFF344968),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : Container(),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        leading: Icon(
                          Icons.person,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          'Account Details',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF344968),
                          ),
                        ),
                        trailing: ButtonTheme(
                          padding: EdgeInsets.all(0),
                          minWidth: 50.0,
                          height: 25.0,
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).hintColor.withOpacity(0.15),
                              offset: Offset(0, 3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: <Widget>[
                            ListTile(
                              onTap: () {},
                              dense: true,
                              leading: Text(
                                "Full Name:",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1DBF73),
                                ),
                              ),
                              trailing: Text(
                                document["name"],
                                style: TextStyle(
                                  fontSize: 14.0, 
                                  color: Color(0xFF344968),
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              onTap: () {},
                              dense: true,
                              leading: Text(
                                "Phone:",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1DBF73),
                                ),
                              ),
                              trailing: Text(
                                document["phone"],
                                style: TextStyle(
                                  fontSize: 14.0, 
                                  color: Color(0xFF344968),
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              onTap: () {},
                              dense: true,
                              leading: Text(
                                "Email:",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1DBF73),
                                ),
                              ),
                              trailing: Text(
                                document["email"],
                                style: TextStyle(
                                  fontSize: 14.0, 
                                  color: Color(0xFF344968),
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              onTap: () {},
                              dense: true,
                              leading: Text(
                                "Address:",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1DBF73),
                                ),
                              ),
                              trailing: Text(
                                document["address"],
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 14.0, 
                                  color: Color(0xFF344968),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(height:100,child:Center(child:Text('No Details found')));
          }
        },
      );
  }
}
