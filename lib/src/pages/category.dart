import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/elements/FoodGridItemWidget.dart';
import 'package:raterestro/src/elements/FoodListItemWidget.dart';
import 'package:raterestro/src/elements/SearchBarWidget.dart';
import 'package:raterestro/src/elements/ShoppingCartButtonWidget.dart';
import 'package:raterestro/src/models/category.dart';
import 'package:raterestro/src/models/food.dart';

class CategoryWidget extends StatefulWidget {

  final String categoryID;
  final Category category;
  CategoryWidget({this.category, this.categoryID});

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  String layout = 'grid';
  bool list = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Category',
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1DBF73),
              letterSpacing: 0,
            ),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.category,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  widget.category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF344968),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          this.layout = 'list';
                        });
                      },
                      icon: Icon(
                        Icons.format_list_bulleted,
                        color: this.layout == 'list' ? Theme.of(context).accentColor : Theme.of(context).focusColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          this.layout = 'grid';
                        });
                      },
                      icon: Icon(
                        Icons.apps,
                        color: this.layout == 'grid' ? Theme.of(context).accentColor : Theme.of(context).focusColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("foodItems").where('categoryName', isEqualTo: widget.category.name).orderBy("rate").snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return new Text('${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularLoadingWidget(height: 500);
                  default:
                    final int count = snapshot.data.documents.length;
                    return count > 0
                    ? this.layout != 'grid' 
                      ? Offstage(
                          offstage: this.layout != 'list',
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: count,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 10);
                            },
                            itemBuilder: (context, index) {
                              final DocumentSnapshot document = snapshot.data.documents[index];
                              Food data = Food.fromJSON(document.data);
                              final foodID = snapshot.data.documents[index].documentID;
                              return FoodListItemWidget(
                                food: data,
                                foodID: foodID,
                              );
                            },
                          ),
                        )
                        : Offstage(
                            offstage: this.layout != 'grid',
                            child: GridView.count(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 20,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              // Create a grid with 2 columns. If you change the scrollDirection to
                              // horizontal, this produces 2 rows.
                              crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
                              // Generate 100 widgets that display their index in the List.
                              children: List.generate(count, (index) {
                                final DocumentSnapshot document = snapshot.data.documents[index];
                                Food data = Food.fromJSON(document.data);
                                final foodID = snapshot.data.documents[index].documentID;
                                return FoodGridItemWidget(
                                  food: data,
                                  foodID:foodID,
                                );
                              }),
                            ),
                          )
                        : Container(height:500,child:Center(child:Text('No FoodItems found')));
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
