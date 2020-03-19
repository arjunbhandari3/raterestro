import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/elements/ReviewItemWidget.dart';
import 'package:raterestro/src/elements/ShoppingCartFloatButtonWidget.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/restaurant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raterestro/src/models/food.dart';
import 'package:raterestro/src/models/review.dart';
import 'package:raterestro/src/models/cart.dart';
import 'package:raterestro/src/services/auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:raterestro/src/services/cart_services_scoped_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:raterestro/src/models/user.dart';

class FoodWidget extends StatefulWidget {
  final String foodID;
  Food food;

  FoodWidget({Key key,this.foodID, this.food}) : super(key: key);

  @override
  _FoodWidgetState createState() {
    return _FoodWidgetState();
  }
}

class _FoodWidgetState extends State<FoodWidget> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  int quantity = 1;
  double total;
  bool loadCart = false;
  double _rating;
  final _addReviewFormKey = GlobalKey<FormState>();
  String review;

  @override
  void initState() {
    super.initState();
    total = widget.food.price ?? '0.00';
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CartScopedModel>(
      builder: (context, child, model) {
        var isAdded = true;
        model.cartItems.forEach((f) {
          if (f.food.name == widget.food.name) {
            isAdded = false;
          }
        });
        return Scaffold(
          key: scaffoldKey,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 120),
                padding: EdgeInsets.only(bottom: 15),
                child: CustomScrollView(
                  primary: true,
                  shrinkWrap: false,
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor:
                          Theme.of(context).accentColor.withOpacity(0.9),
                      expandedHeight: 300,
                      elevation: 0,
                      pinned:true,
                      iconTheme: IconThemeData(
                          color: Theme.of(context).primaryColor),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: Hero(
                          tag: widget.food.id,
                          child: Image.network(
                            widget.food.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Wrap(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex:4,
                                  child: Text(
                                    widget.food.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF344968),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    Helper.getPrice(widget.food.price),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF344968),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Text(
                              "(${widget.food.restaurantName})",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1DBF73),
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: Helper.getStarsList(double.parse(widget.food.rate)),
                            ),
                            SizedBox(height: 30),
                            Text(widget.food.description),
                            ListTile(
                              dense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                              leading: Icon(
                                Icons.recent_actors,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                'Reviews',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                  color:Color(0xFF344968),
                                ),
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance.collection("foodItems").document(widget.foodID).collection("reviews").snapshots(),
                              builder:
                                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) return new Text('${snapshot.error}');
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return CircularLoadingWidget(height: 288);
                                  default:
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: ListView.separated(
                                        padding: EdgeInsets.all(0),
                                        itemBuilder: (context, index) {
                                          final DocumentSnapshot document = snapshot.data.documents[index];
                                          Review data = Review.fromJSON(document.data);
                                          final reviewID = snapshot.data.documents[index].documentID;
                                          return ReviewItemWidget(review: data);
                                        },
                                        separatorBuilder: (context, index) {
                                          return Divider();
                                          // return SizedBox(height: 20);
                                        },
                                        itemCount: snapshot.data.documents.length,
                                        primary: false,
                                        shrinkWrap: true,
                                      ),
                                    );
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 32,
                right: 20,
                child: loadCart
                  ? Container()
                  : ShoppingCartFloatButtonWidget(
                      iconColor: Theme.of(context).primaryColor,
                      labelColor: Theme.of(context).hintColor,
                    ),
              ),
              Positioned(
                bottom: 150,
                right: 20,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return SimpleDialog(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                          title: Row(
                            children: <Widget>[
                              Icon(Icons.person_add),
                              SizedBox(width: 10),
                              Text(
                                'Add Review',
                                style: TextStyle(fontSize: 14.0, color: Colors.black),
                              ),
                            ],
                          ),
                          children: <Widget>[
                            Form(
                              key: _addReviewFormKey,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                                      title: Text(
                                        'Rating',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF344968),
                                        ),
                                      ),
                                    ),
                                  ),
                                  RatingBar(
                                    initialRating: 0,
                                    minRating: 0.5,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    unratedColor: Colors.amber.withAlpha(50),
                                    itemCount: 5,
                                    itemSize: 30.0,
                                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        _rating = rating;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                    child: ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                                      title: Text(
                                        'Review',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF344968),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    onSaved: (input) => review = input,
                                    validator: (input) => input.length < 3 ? 'Should be more than 3 characters' : null,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: "Review",
                                      labelStyle: TextStyle(color: Colors.black),
                                      contentPadding: EdgeInsets.all(12),
                                      prefixIcon: Icon(Icons.edit, color: Theme.of(context).accentColor),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Theme.of(context).accentColor)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            MaterialButton(
                              onPressed: () {
                                submitReview();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(color: Theme.of(context).accentColor),
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  });
                  },
                  heroTag: 'bottom1',
                  isExtended: true,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Add Review', style: TextStyle(color: Colors.white),),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 140,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Quantity',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color:Color(0xFF344968),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    model.decrementQuantity();
                                  },
                                  iconSize: 30,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  icon: Icon(Icons.remove_circle_outline),
                                  color: Theme.of(context).hintColor,
                                ),
                                Text(
                                  '${model.quantity}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color:Color(0xFF344968),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    model.incrementQuantity();
                                  },
                                  iconSize: 30,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  icon: Icon(Icons.add_circle_outline),
                                  color: Theme.of(context).hintColor,
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Stack(
                          fit: StackFit.loose,
                          alignment: AlignmentDirectional.centerEnd,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  40,
                              child: isAdded 
                              ? FlatButton(
                                onPressed: () {
                                  model.addToCart(widget.food,model.quantity);
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
                                    'Add to Cart',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColor),
                                  ),
                                ),
                              )
                              : FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacementNamed('/Cart');
                                  },
                                  padding:
                                      EdgeInsets.symmetric(vertical: 14),
                                  color: Theme.of(context).accentColor,
                                  shape: StadiumBorder(),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      'View Cart',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20),
                              child: Text(
                                Helper.getPrice(calculateTotal(model.quantity)),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor
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
      },
    );
  }

  double calculateTotal(int quantity) {
    print("itemPrice: " + widget.food.price.toString());
    total = widget.food.price ?? 0.0;
    total *= quantity;
    print("total: " + total.toString());
    return total;
  }
  
  void submitReview() async {
    if (_addReviewFormKey.currentState.validate()) {
        _addReviewFormKey.currentState.save();
          if (widget.foodID != null) {
          await Firestore.instance
          .collection('foodItems')
          .document(widget.foodID)
          .get()
          .then((DocumentSnapshot ds) async{
            if (ds.exists) {
              await Firestore.instance
              .collection('foodItems')
              .document(widget.foodID)
              .collection('reviews')
              .add({
                "review": review,
                "rate":_rating,
                "userName": auth.currentUser.name,
                'userImage': auth.currentUser.image,
              }).then((value) {
                Fluttertoast.showToast(
                  msg: 'Your review is successfully added.',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              });
            } else {
              scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Something Went Wrong.'),
              ));
            }
          });
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("No Internet Connection. Please check your Internet Connection."),
          ));
        }
    }
  }
}