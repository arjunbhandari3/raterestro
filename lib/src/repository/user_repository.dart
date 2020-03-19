import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:raterestro/src/services/auth.dart';
import 'package:flutter/widgets.dart';
import 'package:raterestro/src/helpers/helper.dart';
import 'package:raterestro/src/models/user.dart';

Future<String> uploadPhoto(File image, String imageType) async {
  String url = "";

  try {

    String imageFileName = Uuid().v1() + extension(image.path);

    print("uploadPhoto imageFileName $imageFileName");

    StorageReference ref = FirebaseStorage.instance.ref().child(imageType).child(imageFileName);
    StorageUploadTask uploadTask = ref.putFile(image);
    url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print("$imageFileName uploaded successfully.");
  } on Exception catch (e) {
    print("uploadPhoto failed $e");

    return null;
  }

  return url;
}

Future<Null> updateUser() async {
  await Firestore.instance
    .collection('users')
    .document(auth.currentUser.id)
    .setData({
      'id': auth.currentUser.id,
      'name': auth.currentUser.name,
      'phone': auth.currentUser.phone,
      'email': auth.currentUser.email,
      'address':auth.currentUser.address,
      'image':auth.currentUser.image,
      'fcmToken': auth.currentUser.fcmToken,
      'loggedAt': FieldValue.serverTimestamp(),
      'role': auth.currentUser.role,
      "coin": auth.currentUser.coin,
    });
}
