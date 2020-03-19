import 'package:flutter/material.dart';
import 'package:raterestro/src/models/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raterestro/src/models/order.dart';
import 'package:raterestro/src/models/user.dart';
import 'package:raterestro/src/models/food_order.dart';
import 'package:raterestro/src/models/order_status.dart';
import 'package:raterestro/src/services/auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:raterestro/src/services/cart_services_scoped_model.dart';

class OrderSuccessWidget extends StatefulWidget {
  final CartScopedModel model;
  double total;
  final String orderDate;
  final String orderTime;
  List<Cart> cartlist = <Cart>[];
  final String method;
  final String orderAddress;

  OrderSuccessWidget({Key key,this.total,this.model,this.orderDate,this.orderTime, this.orderAddress,this.cartlist,this.method }) : super(key: key);

  @override
  _OrderSuccessWidgetState createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState extends State<OrderSuccessWidget> {

  bool loading = true;
  @override
  void initState() {
    bool loading = true;
    addOrder();
    super.initState();
  }

  addOrder() async {
    try {
      await Firestore.instance
      .collection('orders')
      .add({
        'id':DateTime.now().toString(),
        'orderStatus': "Order Placed",
        'totalAmount':widget.total,
        'orderDate': widget.orderDate,
        'orderAddress': widget.orderAddress,
        'orderTime': widget.orderTime,
        'user': auth.currentUser.toMap(),
        'foodOrders': widget.cartlist.map((item) => { 'food': item.food.toMap(), 'quantity': item.quantity}).toList(),
        'paymentMethod': widget.method,
        'paymentStatus': 'Pending'
      }
      ).then((value) async{
          
          await Firestore.instance
          .collection('users')
          .document(auth.currentUser.id)
          .updateData({
            "coin": FieldValue.increment(5),
          });
          widget.model.clearCart();
          setState(() {
            loading = false;
          });
      });
    } catch (e) {
      print(e.message);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Something went Wrong, try again"
          ),
      ));
    }
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).hintColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Confirmation",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1DBF73),
            letterSpacing: 1.3,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            alignment: AlignmentDirectional.center,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: MediaQuery.of(context).size.width / 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                            Colors.green.withOpacity(1),
                            Colors.green.withOpacity(0.2),
                          ])),
                      child: loading
                        ? Padding(
                          padding: EdgeInsets.all(55),
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Theme.of(context).scaffoldBackgroundColor),
                          ),
                        )
                        :Icon(
                          Icons.check,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 90,
                        ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                !loading
                ? Opacity(
                  opacity: 0.4,
                  child: Text(
                    "Your order has been successfully submitted!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF120068),
                    ),
                  ),
                )
                : Container(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 150,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)
                ],
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Total: ",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF344968),
                            ),
                          ),
                        ),
                        Text(
                          Helper.getPrice(widget.total),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1DBF73),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/Pages', arguments: 2);
                        },
                        padding: EdgeInsets.symmetric(vertical: 14),
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                        child: Text(
                          "View My Orders",
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
