import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/elements/DrawerWidget.dart';
import 'package:raterestro/src/elements/FoodItemWidget.dart';
import 'package:raterestro/src/elements/ShoppingCartFloatButtonWidget.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:raterestro/src/models/restaurant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raterestro/src/elements/FoodItemWidget.dart';
import 'package:raterestro/src/elements/ReviewItemWidget.dart';
import 'package:raterestro/src/models/food.dart';
import 'package:raterestro/src/pages/menu_list.dart';
import 'package:raterestro/src/pages/food.dart';
import 'package:raterestro/src/models/review.dart';
import 'package:raterestro/src/pages/map.dart';
import 'package:raterestro/src/models/user.dart';
import 'package:raterestro/src/services/auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailsWidget extends StatefulWidget {

  final String restaurantID;
  final Restaurant restaurant;
  DetailsWidget({this.restaurant, this.restaurantID});

  @override
  _DetailsWidgetState createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {

  @override
  void initState() {
    super.initState();
  }
  
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double _rating;
  final _addReviewFormKey = GlobalKey<FormState>();
  String review;

  _launchCaller() async {
    var url = "tel:${widget.restaurant.phone}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton.extended(
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
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => MenuWidget(restaurantID: widget.restaurantID,restaurant:widget.restaurant),
                  ),
                );
              },
              heroTag: 'bottom2',
              isExtended: true,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              icon: Icon(Icons.restaurant, color: Colors.white),
              label: Text('Menu', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                expandedHeight: 300,
                elevation: 0,
                pinned: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Hero(
                    tag: widget.restaurant.image,
                    child: Image.network(
                      widget.restaurant.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 10, top: 25),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.restaurant.name,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF344968),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 32,
                            child: Chip(
                              padding: EdgeInsets.all(0),
                              label: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    widget.restaurant.rate,
                                    style: TextStyle(
                                      fontSize: 14.0, 
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star_border,
                                    color: Theme.of(context)
                                        .primaryColor,
                                    size: 16,
                                  ),
                                ],
                              ),
                              backgroundColor: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.9),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Text(
                        widget.restaurant.description,
                        style: TextStyle(
                          fontSize: 14.0, 
                          color:Color(0xFF344968),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.stars,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          'Information',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF344968),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      margin:
                          const EdgeInsets.symmetric(vertical: 5),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        widget.restaurant.information,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14.0, 
                          color: Color(0xFF344968),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.map,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          'Address',
                          style:TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF344968),
                          ),
                        ),
                        trailing: Text(
                          'View Map',
                          style:TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF344968),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      margin:
                          const EdgeInsets.symmetric(vertical: 5),
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.restaurant.address,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 14.0, 
                                color: Color(0xFF344968),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => MapWidget(
                                      currentRestaurant:widget.restaurant,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.directions,
                                color:
                                    Theme.of(context).primaryColor,
                                size: 24,
                              ),
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.9),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.phone,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          'Contact Details',
                          style:TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF344968),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      margin:
                          const EdgeInsets.symmetric(vertical: 5),
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${widget.restaurant.phone} \n${widget.restaurant.mobile}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.0, 
                                color: Color(0xFF344968),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                _launchCaller();
                              },
                              child: Icon(
                                Icons.call,
                                color:
                                    Theme.of(context).primaryColor,
                                size: 24,
                              ),
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.9),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20),
                    child: ListTile(
                      dense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.restaurant,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        'Featured Foods',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF344968),
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("foodItems").where('restaurantName', isEqualTo: widget.restaurant.name).orderBy("featured").snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) return new Text('${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return CircularLoadingWidget(height: 288);
                        default:
                          return ListView.separated(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: snapshot.data.documents.length,
                              separatorBuilder: (context, index) {
                                  return SizedBox(height: 10);
                              },
                              itemBuilder: (context, index) {
                                final DocumentSnapshot document = snapshot.data.documents[index];
                                Food data = Food.fromJSON(document.data);
                                final foodID = snapshot.data.documents[index].documentID;
                                return InkWell(
                                  splashColor: Theme.of(context).accentColor,
                                  focusColor: Theme.of(context).accentColor,
                                  highlightColor: Theme.of(context).primaryColor,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => FoodWidget(food:data,foodID:foodID),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    // height: 80,
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
                                            image: DecorationImage(image: NetworkImage(data.image), fit: BoxFit.cover),
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
                                                      data.name,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight: FontWeight.w500,
                                                        color:Color(0xFF344968),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: Helper.getStarsList(double.parse(data.rate)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                Helper.getPrice(data.price), 
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF344968),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                          );
                        }
                      },
                    ),
                    SizedBox(height: 100),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.recent_actors,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          'What They Say ?',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF344968),
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("restaurants").document(widget.restaurantID).collection("reviews").snapshots(),
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
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 32,
            right: 20,
            child: ShoppingCartFloatButtonWidget(
              iconColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }

  void submitReview() async {
    if (_addReviewFormKey.currentState.validate()) {
        _addReviewFormKey.currentState.save();
          if (widget.restaurantID != null) {
          // Handle logged in state 
          await Firestore.instance
          .collection('restaurants')
          .document(widget.restaurantID)
          .get()
          .then((DocumentSnapshot ds) async{
            if (ds.exists) {
              await Firestore.instance
              .collection('restaurants')
              .document(widget.restaurantID)
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
