import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:raterestro/src/models/food_order.dart';

class Helper {

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  static Future<Marker> getMarker(Map<String, dynamic> res,double latitude, double longitude,double distance) async {
    final Marker marker = Marker(
        markerId: MarkerId(res['name']),
        icon: BitmapDescriptor.defaultMarker,
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(
          title: res['name'],
          snippet: distance.toStringAsFixed(2) + ' km',
          onTap: () {
            print('infowi tap');
          },
        ),
        position: LatLng(latitude, longitude));
    return marker;
  }

  static Future<Marker> getMyPositionMarker(double latitude, double longitude) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/img/marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(Random().nextInt(100).toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(
          title: "You are here",
        ),
        position: LatLng(latitude, longitude));

    return marker;
  }

  static List<Icon> getStarsList(double rate) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: 18, color: Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: 18, color: Color(0xFFFFB24D)));
    }
    list.addAll(
        List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: 18, color: Color(0xFFFFB24D));
    }));
    return list;
  }

  static String getPrice(double myPrice) {
    if (myPrice != null) {
      return 'Rs. ${myPrice.toStringAsFixed(2)}';
    }
    return 'Rs. 0.00';
  }
  

  static String getTotalOrderPrice(FoodOrder foodOrder) {
    double total = foodOrder.price * foodOrder.quantity;
    return getPrice(total);
  }

  static String getDistance(double distance) {
    return distance != null ? distance.toStringAsFixed(2) + " km" : "";
  }
}
