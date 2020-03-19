import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/elements/CartItemWidget.dart';
import 'package:raterestro/src/elements/EmptyCartWidget.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/cart.dart';
import 'package:raterestro/src/models/food.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:raterestro/src/services/cart_services_scoped_model.dart';
import 'package:raterestro/src/pages/food.dart';
import 'package:raterestro/src/pages/deliveryCheckout.dart';
import 'package:raterestro/src/services/auth.dart';

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
 
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CartScopedModel>(
      builder: (context, child, model){
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Cart',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1DBF73),
                letterSpacing: 1.3,
              ),
            ),
          ),
          body: model.cartItems.length > 0
            ? Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 150),
                padding: EdgeInsets.only(bottom: 15),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.shopping_cart,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            'Shopping Cart',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF344968),
                            ),
                          ),
                          subtitle: Text(
                            'Verify your quantity and click checkout',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.0, 
                              color: Color(0xFF8C98A8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: model.cartItems.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 15);
                        },
                        itemBuilder: (context, index) {
                          var cartItem = model.cartItems[index];
                          return InkWell(
                            splashColor: Theme.of(context).accentColor,
                            focusColor: Theme.of(context).accentColor,
                            highlightColor: Theme.of(context).primaryColor,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => FoodWidget(food:cartItem.food),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.9),
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context).focusColor.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: Offset(0, 2)),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 90,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      image: DecorationImage(
                                          image: NetworkImage(cartItem.food.image),
                                          fit: BoxFit.cover),
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
                                                cartItem.food.name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF344968),
                                                ),
                                              ),
                                              Text(
                                                "(${cartItem.food.restaurantName})",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF1DBF73),
                                                ),
                                              ),
                                              
                                              Text(
                                                Helper.getPrice(cartItem.food.price),
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500,
                                                  color:Color(0xFF344968),
                                                ),
                                              ),
                                              SizedBox(height:5),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Total: ",
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF344968),
                                                    ),
                                                  ),
                                                  Text(
                                                    " Rs. ${cartItem.food.price * cartItem.quantity}",
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF1DBF73),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                   model.updateItemCount(index, true);
                                                });
                                              },
                                              iconSize: 30,
                                              padding: EdgeInsets.symmetric(horizontal: 5),
                                              icon: Icon(Icons.add_circle_outline),
                                              color: Theme.of(context).hintColor,
                                            ),
                                            Text(
                                              cartItem.quantity.toString(),
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF344968),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  model.updateItemCount(index, false);
                                                  if(cartItem.quantity == 0){
                                                    scaffoldKey.currentState.showSnackBar(SnackBar(
                                                      content: Text("  ${cartItem.food.name} is removed from your cart"),
                                                    ));
                                                  }
                                                });
                                              },
                                              iconSize: 30,
                                              padding: EdgeInsets.symmetric(horizontal: 5),
                                              icon: Icon(Icons.remove_circle_outline),
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 110,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context)
                                .focusColor
                                .withOpacity(0.15),
                            offset: Offset(0, -2),
                            blurRadius: 5.0)
                      ]),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Stack(
                          fit: StackFit.loose,
                          alignment: AlignmentDirectional.centerEnd,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  40,
                              child: FlatButton(
                                onPressed: () {
                                  model.cartItems.length > 0
                                  ? Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DeliveryCheckoutWidget(model,model.cartItems,model.getCartTotal()),
                                      ),
                                    )
                                  : scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text("Cart is Empty"),
                                      duration: Duration(seconds: 4),
                                    ));
                                },
                                padding:
                                    EdgeInsets.symmetric(vertical: 14),
                                color: Theme.of(context).accentColor,
                                shape: StadiumBorder(),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    'Continue to Checkout',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColor),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20),
                              child: Text(
                                Helper.getPrice(model.getCartTotal()),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
          : EmptyCartWidget()
        );
      }
    );
  }

}
