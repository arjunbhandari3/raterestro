import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/src/point.dart';
import 'package:rxdart/rxdart.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/restaurant.dart';
import 'package:raterestro/src/services/location_services.dart';
import 'package:raterestro/src/elements/CircularLoadingWidget.dart';
import 'package:raterestro/src/elements/CardsCarouselWidget.dart';

class MapWidget extends StatefulWidget {
  Restaurant currentRestaurant;

  MapWidget({Key key, this.currentRestaurant}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  List<Marker> allMarkers = <Marker>[];
  LocationData currentLocation;
  CameraPosition cameraPosition;
  Completer<GoogleMapController> mapController = Completer();
  LocationData locationData;

  Geoflutterfire geo = Geoflutterfire();

  BehaviorSubject<double> radius = BehaviorSubject.seeded(100);
  Stream<dynamic> query;

  StreamSubscription subscription;

  @override
  void initState() {
    setState(() {
      getCurrentLocation();
    });
    super.initState();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  void getCurrentLocation() async {
    try {
      currentLocation = await getSavedCurrentLocation();
      setState(() {
        cameraPosition = CameraPosition(
          target: LatLng(widget.currentRestaurant.position.latitude, widget.currentRestaurant.position.longitude),
          zoom: 14.4746,
        );
      });
      Helper.getMyPositionMarker(currentLocation.latitude, currentLocation.longitude).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  Future<void> goCurrentLocation() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 14.4746,
    )));
  }

  void listenForNearRestaurants(LocationData myLocation) async {
    var ref = Firestore.instance.collection('restaurants');
    GeoFirePoint center = geo.point(latitude: myLocation.latitude, longitude: myLocation.longitude);
    // subscribe to query
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
        center: center,
        radius: rad,
        field: 'position',
        strictMode: true
      );
    }).listen(_updateMarkers);
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    print(documentList);
    documentList.forEach((DocumentSnapshot document) async{
      print(document);
      Restaurant restaurant = Restaurant.fromJSON(document.data);
      final restaurantID = document.documentID;
      GeoPoint pos = document.data['position']['geopoint'];
      double distance = document.data['distance'] * 1.609344;
      print(distance);
      await Firestore.instance
      .collection('restaurants')
      .document(restaurantID)
      .updateData({
        'distance': distance,
      });
      Helper.getMarker(restaurant.toMap(),pos.latitude,pos.longitude,distance).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
    });
  }

  void getRestaurantsOfArea() async {
    setState(() {
      LocationData areaLocation = LocationData.fromMap(
          {"latitude": cameraPosition.target.latitude, "longitude": cameraPosition.target.longitude});
      if (cameraPosition != null) {
        listenForNearRestaurants(currentLocation);
      } else {
        listenForNearRestaurants(areaLocation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Maps Explorer',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1DBF73),
            letterSpacing: 1.3,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.my_location,
              color: Theme.of(context).hintColor,
            ),
            onPressed: () {
              goCurrentLocation();
            },
          )
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          cameraPosition == null
          ? CircularLoadingWidget(height: 0)
          : GoogleMap(
            mapToolbarEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: cameraPosition,
            markers: Set.from(allMarkers),
            onMapCreated: (GoogleMapController controller) {
              mapController.complete(controller);
            },
            onCameraMove: (CameraPosition _cameraPosition) {
              cameraPosition = _cameraPosition;
            },
            onCameraIdle: () {
              getRestaurantsOfArea();
            },
          ),
          CardsCarouselWidget(),
        ],
      ),
    );
  }
}
