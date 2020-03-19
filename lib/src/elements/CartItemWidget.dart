import 'package:flutter/material.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/cart.dart';
import 'package:raterestro/src/models/food.dart';

class CartItemWidget extends StatefulWidget {
  Cart cart;
  final String cartID;
  Food food;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;

  CartItemWidget(
      {Key key,
      this.cart,
      this.cartID,
      this.food,
      this.increment,
      this.decrement,
      this.onDismissed})
      : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.cartID),
      onDismissed: (direction) {
        setState(() {
          widget.onDismissed();
        });
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {
          // Navigator.of(context).pushNamed('/Food',
          //     arguments: RouteArgument(
          //         id: widget.cart.food.id));
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
                      image: NetworkImage(widget.food.image),
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
                            widget.food.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color:Color(0xFF344968),
                            ),
                          ),
                          Text(
                            Helper.getPrice(widget.food.price),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF344968),
                            ),
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
                              widget.increment();
                            });
                          },
                          iconSize: 30,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          icon: Icon(Icons.add_circle_outline),
                          color: Theme.of(context).hintColor,
                        ),
                        Text(
                          widget.cart.quantity.toInt().toString(),
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color:Color(0xFF344968),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.decrement();
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
      ),
    );
  }
}
