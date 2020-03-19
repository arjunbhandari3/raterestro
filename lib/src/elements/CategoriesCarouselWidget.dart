import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/elements/CategoriesCarouselItemWidget.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/models/category.dart';
import 'package:raterestro/src/pages/category.dart';

class CategoriesCarouselWidget extends StatelessWidget {

  CategoriesCarouselWidget({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("categories").snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularLoadingWidget(height: 150);
          default:
          final int count = snapshot.data.documents.length;
          return count > 0
            ?  Container(
                height: 150,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot document = snapshot.data.documents[index];
                    var data = Category.fromJSON(document.data);
                    final categoryID = snapshot.data.documents[index].documentID;
                    double _marginLeft = 0;
                    (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => CategoryWidget(category:data,categoryID:categoryID),
                          ),
                        );
                      },
                      child: CategoriesCarouselItemWidget(
                        marginLeft: _marginLeft,
                        category: data,
                      ),
                    );
                  },
                ),
            )
            : Container(height:100,child:Center(child:Text('No Categories found')));
          }
        },
      );
  }
}
