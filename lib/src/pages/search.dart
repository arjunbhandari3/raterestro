import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/elements/SearchBarWidget.dart';
import 'package:raterestro/src/elements/CardWidget.dart';

class SearchPageWidget extends StatefulWidget {
  @override
  _SearchPageWidgetState createState() => _SearchPageWidgetState();
}

class _SearchPageWidgetState extends State<SearchPageWidget> {
  // List<dynamic> data = [];
  
  bool loading = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
        loading = true;
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      Firestore.instance
        .collection("restaurants")
        .where("key", isEqualTo: value.substring(0, 1).toUpperCase())
        .getDocuments().then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
          print(queryResultSet);
        }
        setState(() {
          loading = false;
        });
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
            print(tempSearchStore);
            print('tempSearchStore');
          });
        }
      });
      setState(() {
        loading = false;
      });
    }
  }

  // void searchResult(String keyword) async {
  //   setState(() {
  //     loading = true;
  //   });

    // try {
    //   documentList = (await Firestore.instance
    //     .collection("restaurnats")
    //     .where("name", isEqualTo: keyword)
    //     .getDocuments())
    //     .documents;
    //   setState(() {
    //     loading = false;
    //   });
    //   setState(() {
    //     data = data;
    //   });
    // } catch (e) {
    //   setState(() {
    //     loading = false;
    //   });
    //   Fluttertoast.showToast(
    //       msg: "Unable to fetch",
    //       toastLength: Toast.LENGTH_LONG,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIos: 1,
    //       backgroundColor: kOrange,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }
  // }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (text) {
                      initiateSearch(text);
                    },
                    onSubmitted: (text) {
                      print(text);
                      // searchResult(text);
                      initiateSearch(text);
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'Search for restaurants or foods',
                      hintStyle: TextStyle(
                        fontSize: 14.0, 
                        color: Color(0xFF8C98A8),
                      ),
                      prefixIcon: Icon(Icons.search,
                          color: Theme.of(context).accentColor),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).focusColor.withOpacity(0.1))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).focusColor.withOpacity(0.3))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).focusColor.withOpacity(0.1))),
                    ),
                  ),
                ),
                loading
                  ? CircularLoadingWidget(height: 200)
                  : Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      title: Text(
                        'Recents Search',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF344968),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: queryResultSet.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Theme.of(context).accentColor,
                        focusColor: Theme.of(context).accentColor,
                        highlightColor: Theme.of(context).primaryColor,
                        onTap: () {
                          
                        },
                        child: Container(
                          // height: 80,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.9),
                            boxShadow: [
                              BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  image: DecorationImage(image: NetworkImage('${queryResultSet[index]["image"]}'), fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(width: 15),
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${queryResultSet[index]["name"]}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500,
                                              color:Color(0xFF344968),
                                            ),
                                          ),
                                          Text(
                                            '${queryResultSet[index]["address"]}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 12.0, 
                                              color: Color(0xFF8C98A8),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: Helper.getStarsList(double.parse('${queryResultSet[index]["rate"]}')),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              // Expanded(
              //   flex: 7,
              //   child: 
              //   // loading
              //   //     ? CircularLoadingWidget(height: 500)
              //   //     : 
              //   Container(
              //     //height: 100.0,
              //     // color: Theme.of(context).accentColor,r
              //     child: ListView.builder(
              //       itemCount: tempSearchStore.length,
              //       itemBuilder: (context, index) {
              //         return ListTile(
              //           title: InkWell(
              //             splashColor: Theme.of(context).accentColor,
              //             focusColor: Theme.of(context).accentColor,
              //             highlightColor: Theme.of(context).primaryColor,
              //             onTap: () {},
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: <Widget>[
              //                 Text('${tempSearchStore[index]["name"]}'),
              //                 Text('£ ${tempSearchStore[index]["price"]}')
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // //       // SearchList(data: tempSearchStore, context: context),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}


class SearchList extends StatelessWidget {
  const SearchList({
    Key key,
    @required this.data,
    @required this.context,
  }) : super(key: key);

  final List data;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 100.0,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: InkWell(
              splashColor: Theme.of(context).accentColor,
              focusColor: Theme.of(context).accentColor,
              highlightColor: Theme.of(context).primaryColor,
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${data[index]["name"]}'),
                  Text('£ ${data[index]["price"]}')
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

