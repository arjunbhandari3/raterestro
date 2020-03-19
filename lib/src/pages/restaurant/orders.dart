import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/models/order.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/food_order.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/elements/OrderItemWidget.dart';
import 'package:raterestro/src/elements/SearchBarWidget.dart';

class OrdersWidget extends StatefulWidget {
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      key: scaffoldKey,
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
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('orders').orderBy("id", descending: true).snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return new Text('${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularLoadingWidget(height: 288);
                  default:
                  print(snapshot.data.documents);
                  return snapshot.hasData
                    ?  ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot document = snapshot.data.documents[index];
                          var data = Order.fromJSON(document.data);
                          final orderID = snapshot.data.documents[index].documentID;
                          return Theme(
                            data: theme,
                            child: ExpansionTile(
                              initiallyExpanded: true,
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Order Id: #${index}'),
                                        Text(
                                          'Orderer: ${data.user.name}',
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 14.0, 
                                            color: Color(0xFF344968),
                                          ),
                                        ),
                                        Text(
                                          'Order Address: ${data.orderAddress}',
                                          style: TextStyle(
                                            fontSize: 12.0, 
                                            color: Color(0xFF8C98A8),
                                          ),
                                        ),
                                      ],
                                    ), 
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        Helper.getPrice(data.totalAmount),
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF344968),
                                        ),
                                      ),
                                      Text(
                                        data.orderStatus,
                                        style: TextStyle(
                                          fontSize: 12.0, 
                                          color: Color(0xFF8C98A8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              children: List.generate(data.foodOrders.length, (i) {
                                return OrderItemWidget(
                                  foodOrder: data.foodOrders[i],
                                  order : data
                                );
                              }),
                            ),
                          );
                        },
                      )
                      : Container(height:500,child:Center(child:Text('No Orders have been made.')));
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
