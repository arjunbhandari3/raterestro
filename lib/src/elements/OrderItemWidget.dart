import 'package:flutter/material.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/food_order.dart';
import 'package:raterestro/src/models/order.dart';

class OrderItemWidget extends StatefulWidget {
  final FoodOrder foodOrder;
  final Order order;

  OrderItemWidget({Key key, this.foodOrder, this.order})
      : super(key: key);

  @override
  _OrderItemWidgetState createState() {
    return _OrderItemWidgetState();
  }
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                  image: NetworkImage(widget.foodOrder.food.image),
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
                        widget.foodOrder.food.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color:Color(0xFF344968),
                        ),
                      ),
                      Text(
                        widget.foodOrder.food.restaurantName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12.0, 
                          color: Color(0xFF8C98A8),
                        ),
                      ),
                      Text(
                        "Price: ${widget.foodOrder.food.price}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12.0, 
                          fontWeight: FontWeight.w400,
                          color:Color(0xFF344968),
                        ),
                      ),
                      Text(
                        "Quantity: ${widget.foodOrder.quantity}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color:Color(0xFF344968),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      Helper.getPrice(widget.foodOrder.food.price * widget.foodOrder.quantity),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF344968),
                      ),
                    ),
                    Text(
                      widget.order.orderDate,
                      style: TextStyle(
                        fontSize: 12.0, 
                        color: Color(0xFF8C98A8),
                      ),
                    ),
                    Text(
                      widget.order.orderTime,
                      style: TextStyle(
                        fontSize: 12.0, 
                        color: Color(0xFF8C98A8),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
