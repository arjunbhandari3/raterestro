import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/elements/CartItemWidget.dart';
import 'package:raterestro/src/elements/EmptyCartWidget.dart';
import 'package:raterestro/src/pages/payment.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/cart.dart';
import 'package:raterestro/src/models/food.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:raterestro/src/services/cart_services_scoped_model.dart';
import 'package:raterestro/src/pages/food.dart';
import 'package:raterestro/src/services/auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DeliveryCheckoutWidget extends StatefulWidget {
    final CartScopedModel model;
    List<Cart> itemlist = [];
    double total;
    DeliveryCheckoutWidget( this.model,this.itemlist,this.total,);
  @override
  _DeliveryCheckoutWidgetState createState() => _DeliveryCheckoutWidgetState();
}

class _DeliveryCheckoutWidgetState extends State<DeliveryCheckoutWidget> {

  bool dateSelected = false;
  bool timeSelected = false;

  String date = "";
  String time = "";
  String _address;

  TextEditingController addressController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

    void getDate() {
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime.now(),
            maxTime: DateTime(2022, 12, 31), onChanged: (date) {
        print('change $date');
        }, onConfirm: (d) {
        print('confirm $d');
        setState(() {
            dateSelected = true;
            date= DateFormat('EEE, dd MMM, yyyy G').format(d);
            print('confirm $date');
        });
        }, currentTime: DateTime.now(), locale: LocaleType.en);
    }
    void getTime() {
        DatePicker.showTime12hPicker(context, onChanged: (t) {}, onConfirm: (t) {
            setState(() {
                timeSelected = true;
                time = DateFormat('hh:mm a').format(t);
            });
        }, currentTime: DateTime.now(), locale: LocaleType.en);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
                'Delivery',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(left: 20, right: 10),
                                child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                    leading: Icon(
                                        Icons.watch_later,
                                        color: Theme.of(context).hintColor,
                                    ),
                                    title: Text(
                                        'Select Delivery Address & DateTime',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            color:Color(0xFF344968),
                                        ),
                                    ),
                                    subtitle: Text(
                                        'Select Specific address and DateTime',
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
                            Padding(
                                padding: const EdgeInsets.only(left: 25, right: 20),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        Text(
                                            'Set Order Date',
                                            style: new TextStyle(
                                                color: Colors.black,
                                                fontSize:18,
                                            ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context).size.height * .01,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                                getDate();
                                            },
                                            child: Container(
                                                padding: const EdgeInsets.only(left: 25,right:25),
                                                height: MediaQuery.of(context).size.height * .07,
                                                child: Material(
                                                    elevation: 4.0,
                                                    child: Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                                Text(
                                                                    dateSelected? date: "Set Date",
                                                                    textAlign:TextAlign.center,
                                                                    style: new TextStyle(
                                                                        color: Colors.green,
                                                                        fontSize:18,
                                                                    ),
                                                                ), 
                                                                Icon(
                                                                    Icons.calendar_today,
                                                                    color: Theme.of(context).hintColor,
                                                                ),
                                                            ],
                                                        ),
                                                    ),
                                                ),
                                            ),
                                        ), 
                                    ],
                                ),
                            ),
                            SizedBox(
                            	height: 10,
                            ),
                            Divider(),
                            SizedBox(
                            	height: 10,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 25, right: 20),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        Text(
                                            'Set Order Time',
                                            style: new TextStyle(
                                                color: Colors.black,
                                                fontSize:18,
                                            ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context).size.height * .01,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                                getTime();
                                            },
                                            child: Container(
                                                padding: const EdgeInsets.only(left: 25,right:25),
                                                height: MediaQuery.of(context).size.height * .07,
                                                child: Material(
                                                    elevation: 4.0,
                                                    child: Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                                Text(
                                                                    timeSelected? time: "Set Time",
                                                                    textAlign:TextAlign.center,
                                                                    style: new TextStyle(
                                                                        color: Colors.green,
                                                                        fontSize:18,
                                                                    ),
                                                                ), 
                                                                Icon(
                                                                    Icons.watch_later,
                                                                    color: Theme.of(context).hintColor,
                                                                ),
                                                            ],
                                                        ),
                                                    ),
                                                ),
                                            ),
                                        ), 
                                    ],
                                ),
                            ),
                            SizedBox(
                            	height: 10,
                            ),
                            Divider(),
                            SizedBox(
                            	height: 10,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 25, right: 20),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        Text(
                                            'Set Delivery Address ',
                                            style: new TextStyle(
                                                color: Colors.black,
                                                fontSize:18,
                                            ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: TextFormField(
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xFF1DBF73),
                                            ),
                                            keyboardType: TextInputType.text,
                                            controller: addressController,
                                            onSaved: (input) => _address = input,
                                            validator: (input) => input.length < 3
                                                ? 'Should be more than 3 letters'
                                                : null,
                                            decoration: InputDecoration(
                                                labelText: "Address",
                                                labelStyle: new TextStyle(
                                                    color: Colors.black,
                                                    fontSize:18,
                                                ),
                                                contentPadding: EdgeInsets.all(12),
                                                hintText: 'Dhulikhel Kavre',
                                                hintStyle: new TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:18,
                                                ),
                                                prefixIcon: Icon(
                                                    Icons.map,
                                                    color: Colors.black,
                                                ),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context).focusColor.withOpacity(0.5))),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context).focusColor.withOpacity(0.2))),
                                            ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                            SizedBox(
                            	height: 10,
                            ),
							Padding(
                                padding: const EdgeInsets.only(left: 20, right: 10),
                                child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                    leading: Icon(
                                        Icons.check_circle,
                                        color: Theme.of(context).hintColor,
                                    ),
                                    title: Text(
                                        'Review your Orders',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            color:Color(0xFF344968),
                                        ),
                                    ),
                                    subtitle: Text(
                                        'Verify your orders',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.0, 
                                            color: Color(0xFF8C98A8),
                                        ),
                                    ),
                                ),
                            ),
							ListView.separated(
								padding: EdgeInsets.symmetric(vertical: 15),
								scrollDirection: Axis.vertical,
								shrinkWrap: true,
								primary: false,
								itemCount: widget.itemlist.length,
								separatorBuilder: (context, index) {
								return SizedBox(height: 15);
								},
								itemBuilder: (context, index) {
								var item = widget.itemlist[index];
								return InkWell(
									splashColor: Theme.of(context).accentColor,
									focusColor: Theme.of(context).accentColor,
									highlightColor: Theme.of(context).primaryColor,
									onTap: () {
									Navigator.of(context).push(
										MaterialPageRoute(
										builder: (BuildContext context) => FoodWidget(food:item.food),
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
												image: NetworkImage(item.food.image),
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
														item.food.name,
														overflow: TextOverflow.ellipsis,
														maxLines: 2,
														style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight: FontWeight.w600,
                                                            color: Color(0xFF344968),
                                                        ),
													),
													Text(
														"(${item.food.restaurantName})",
														overflow: TextOverflow.ellipsis,
														maxLines: 1,
														style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight: FontWeight.w600,
                                                            color: Color(0xFF1DBF73),
                                                        ),
													),
													
													Text(
														"Quantity:  ${item.quantity}",
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
															" Rs. ${item.food.price * item.quantity}",
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
                    height: 120,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                width: MediaQuery.of(context).size.width - 40,
                                child: FlatButton(
                                onPressed: () {
                                    if (dateSelected == false ) {
                                        var snackBar = SnackBar(content: Text(
                                            "Please Enter Date for Order."));
                                        scaffoldKey.currentState.showSnackBar(snackBar);
                                    }
                                    else if (timeSelected == false) {
                                        var snackBar = SnackBar(content: Text(
                                            "Please Enter Time for Order."));
                                        scaffoldKey.currentState.showSnackBar(snackBar);
                                    } 
                                    else if (addressController.text.length == 0 ) {
                                        var snackBar = SnackBar(content: Text(
                                            "Enter Delivery Address"));
                                        scaffoldKey.currentState.showSnackBar(snackBar);
                                    } 
                                    else {
                                        widget.itemlist.length > 0
                                        ? Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PaymentWidget(widget.model,widget.total,widget.itemlist,date,time,addressController.text),
                                            ),
                                        )
                                        : scaffoldKey.currentState.showSnackBar(SnackBar(
                                            content: Text("No orders made."),
                                            duration: Duration(seconds: 4),
                                        ));
                                    }
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
                                    'Continue to Payment',
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
                                    Helper.getPrice(widget.total),
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
                ),
            ],
        ),
    );
  }

}
