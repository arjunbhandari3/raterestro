import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'dart:convert';

class CustomSearch extends StatefulWidget {
  @override
  _CustomSearchState createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  List<dynamic> data = [];
  bool loading = false;

  void searchResult(String keyword) async {
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onChanged: (text) {},
                  onSubmitted: (text) {
                    print(text);
                    searchResult(text);
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'Search for foods or restaurants',
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
            ),
            Expanded(
              flex: 7,
              child: loading
                  ? CircularLoadingWidget(height: 500)
                  : SearchList(data: data, context: context),
            )
          ],
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
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (BuildContext context) => FoodWidget(food:food,foodID:foodID),
                //   ),
                // );
              },
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
