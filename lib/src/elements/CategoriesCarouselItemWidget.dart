import 'package:flutter/material.dart';
import 'package:raterestro/src/models/category.dart';

// ignore: must_be_immutable
class CategoriesCarouselItemWidget extends StatelessWidget {
  double marginLeft;
  final Category category;
  CategoriesCarouselItemWidget({Key key, this.marginLeft, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: this.marginLeft, right: 20),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)), color: Theme.of(context).accentColor,
            image: DecorationImage(
              image: NetworkImage(category.image,),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          margin: EdgeInsets.only(left: this.marginLeft, right: 20),
          child: Text(
            category.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0, 
              color: Color(0xFF344968),
            ),
          ),
        ),
      ],
    );
  }
}
