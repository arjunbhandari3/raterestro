import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:raterestro/src/services/cart_services_scoped_model.dart';

class ShoppingCartFloatButtonWidget extends StatefulWidget {
  const ShoppingCartFloatButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  _ShoppingCartFloatButtonWidgetState createState() => _ShoppingCartFloatButtonWidgetState();
}

class _ShoppingCartFloatButtonWidgetState extends State<ShoppingCartFloatButtonWidget> {

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CartScopedModel>(
      builder: (context, widget, model) {
        return model.cartItems.length > 0 
          ? SizedBox(
            width: 60,
            height: 60,
            child: RaisedButton(
              padding: EdgeInsets.all(0),
              color: Theme.of(context).accentColor,
              shape: StadiumBorder(),
              onPressed: () {
                Navigator.of(context).pushNamed('/Cart');
              },
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    color: this.widget.iconColor,
                    size: 28,
                  ),
                  Container(
                    child: Text(
                      model.getCartDetails(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.0, 
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    padding: EdgeInsets.all(0),
                    decoration:
                        BoxDecoration(color: this.widget.labelColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                    constraints: BoxConstraints(minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
                  ),
                ],
              ),
            ),
          )
          : Container();
      }
    );
  }
}
