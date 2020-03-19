import 'package:flutter/material.dart';
import 'package:raterestro/src/pages/search.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/Pages', arguments: 1);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Theme.of(context).focusColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 0),
              child: Icon(Icons.search, color: Theme.of(context).accentColor),
            ),
            Text(
              'Search for restaurants or foods',
              style: TextStyle(
                fontSize: 14.0, 
                color: Color(0xFF8C98A8),
              ),
            )
          ],
        ),
      ),
    );
  }
}
