import 'package:flutter/material.dart';

enum ButtonType { positiveButton, negativeButton }

enum AlertType {
  Success,
  Warning,
  Error,
  Internet,
}

enum MediaAlertType {
  AUDIO,
  IMAGE,
  VIDEO,
}

void showImagePickerAlert({
  @required BuildContext context,
  @required GestureTapCallback galleryCallback,
  @required GestureTapCallback cameraCallback,
  bool barrierDismissible = false,
}) {
  showDialog(
    context: context,
    builder: (_) => ImagePickerAlert(
      galleryCallback: galleryCallback,
      cameraCallback: cameraCallback,
    ),
    barrierDismissible: barrierDismissible,
  );
}

class ImagePickerAlert extends StatefulWidget {
  final GestureTapCallback galleryCallback;
  final GestureTapCallback cameraCallback;

  const ImagePickerAlert(
      {Key key, @required this.galleryCallback, @required this.cameraCallback})
      : super(key: key);

  @override
  _ImagePickerAlertState createState() => _ImagePickerAlertState();
}

class _ImagePickerAlertState extends State<ImagePickerAlert>
    with TickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: AlertDialog(
        contentPadding: EdgeInsets.all(5),
        content: Container(
          margin: EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkResponse(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.image,
                            size: 50,
                            color: Color(0xFF1DBF73),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Gallery",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xFF1DBF73)),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      widget.galleryCallback();
                      Navigator.of(context).pop();
                    },
                  ),
                  InkResponse(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.blueAccent,
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Camera",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xFF1DBF73)),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      widget.cameraCallback();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              InkWell(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 40,
                    maxHeight: 40,
                    maxWidth: MediaQuery.of(context).size.width - 40,
                    minWidth: 70,
                  ),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xFFb0b0b0),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
