import 'package:flutter/material.dart';
import 'package:raterestro/src/models/cart.dart';
import 'package:raterestro/src/pages/orderSuccess.dart';
import 'package:raterestro/src/services/cart_services_scoped_model.dart';
import 'package:raterestro/src/models/cart.dart';

class PaymentWidget extends StatelessWidget {
  final CartScopedModel model;
  double total;
  List<Cart> cartlist = [];
  final String date;
  final String time;
  final String address;
  PaymentWidget(this.model,this.total, this.cartlist, this.date,this.time,this.address);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Payment Mode',
          style: TextStyle(
            fontSize: 18.0,
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
            margin: EdgeInsets.only(bottom: 150),
            padding: EdgeInsets.only(bottom: 15),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.monetization_on,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        "Which payment service do you want?",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color:Color(0xFF344968),
                        ),
                      ),
                      subtitle: Text(
                        'Select your prefered payment mode',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0, 
                          color: Color(0xFF8C98A8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    splashColor: Theme.of(context).accentColor,
                    focusColor: Theme.of(context).accentColor,
                    highlightColor: Theme.of(context).primaryColor,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderSuccessWidget(model:model,total:total,cartlist:cartlist,method:"Cash on Delivery",orderDate:date,orderTime:time,orderAddress:address),
                        ),
                      );
                    },
                    child: Container(
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
                              image: DecorationImage(image: AssetImage("assets/img/cash.png"), fit: BoxFit.fill),
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
                                        "Cash on Delivery",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          color:Color(0xFF344968),
                                        ),
                                      ),
                                      Text(
                                        "Click to pay cash on delivery",
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: TextStyle(
                                          fontSize: 12.0, 
                                          color: Color(0xFF8C98A8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Theme.of(context).focusColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    splashColor: Theme.of(context).accentColor,
                    focusColor: Theme.of(context).accentColor,
                    highlightColor: Theme.of(context).primaryColor,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderSuccessWidget(model:model,total:total,cartlist:cartlist,method:"Pay on Pickup",orderDate:date,orderTime:time,orderAddress:address),
                        ),
                      );
                    },
                    child: Container(
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
                              image: DecorationImage(image: AssetImage("assets/img/pay_pickup.png"), fit: BoxFit.fill),
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
                                        "Pay on Pickup",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          color:Color(0xFF344968),
                                        ),
                                      ),
                                      Text(
                                        "Click to pay on pickup",
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: TextStyle(
                                          fontSize: 12.0, 
                                          color: Color(0xFF8C98A8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Theme.of(context).focusColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),       
    );
  }
}
