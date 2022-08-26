import 'dart:io';
import 'settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as Path;

import 'package:geolocator/geolocator.dart';


late File _image;
File image = File('');

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String _title = 'Fish Detection';

  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(title: const Text(_title)),
      body: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  late List _results;
  dynamic temp;
  int i=0;
  bool imageSelect = false;

  set imageUrl(imageUrl) {}

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(model: "assets/fishDetection.tflite",
        labels: "assets/fishDetection.txt"))!;
    print("Models loading status: $res");
  }

  Future imageClassification(File image) async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results = recognitions!;
      _image = image;
      imageSelect = true;
    });
  }

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image = File(pickedFile!.path);
    imageClassification(image);
  }

  Future pickImageC() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    File image = File(pickedFile!.path);
    imageClassification(image);
  }


  @override
  Widget build(BuildContext context) {
    bool showArrows = true;
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      //backgroundColor: Colors.lightBlue,
      //appBar: AppBar(title: const Text(_title)),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /*
              MaterialButton(
                  color: Colors.blue,
                  child: const Text(
                      "Pick Image from Gallery",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: () {
                    pickImage();
                  }
              ),
              MaterialButton(
                  color: Colors.blue,
                  child: const Text(
                      "Pick Image from Camera",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: () {
                    pickImageC();
                  }
              ),

              image != null? Image.file(image!,height: 250,width: 250,): const Text('No Image Selected'),
              */
              const SizedBox(height: 40),
              (imageSelect) ? Container(
                margin: const EdgeInsets.all(10),
                child: Image.file(_image),
              ) : Container(
                margin: const EdgeInsets.all(10),
                child:  Opacity(
                  opacity: 1,
                  child: Center(
                    child: Image.asset('assets/fish-holding-man.jpg'),
                  ),
                ),
              ),
              Container(
                child: FutureBuilder<Position>(
                    future: _determinePosition(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                            children: [
                              TextSpan(
                                text: "Location coordinates: \n" + snapshot.data.toString(),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child:  const Opacity(
                  opacity: 1,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 17,
                          ),
                          children: [
                            TextSpan(
                              text: "Steps:\n\n1) Pose with the fish as shown in the picture.\n"
                                  "2) Click on",
                            ),
                            WidgetSpan(
                              child: Icon(Icons.image),
                            ),
                            TextSpan(
                              text: "to capture image from Gallery.\n3) Click on",
                            ),
                            WidgetSpan(
                              child: Icon(Icons.camera_alt),
                            ),
                            TextSpan(
                              text: "to capture image from Camera.",
                            ),
                          ],
                        ),
                      )
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: (imageSelect) ? _results.map((result) {temp=result;
                  return Card(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(
                        "${result['label']} - ${result['confidence']
                            .toStringAsFixed(2)}" ,
                        style: const TextStyle(color: Color(0xff064273),
                            fontSize: 18),
                      ),
                    ),
                  );
                  }).toList() : [],

                ),
              ),

            ],
          )
      ),

      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [ FloatingActionButton(
            backgroundColor: const Color(0xff064273),
            onPressed: () {
              pickImage();
              uploadImage(context);
            },
            tooltip: "Pick Image from Gallery",
            child: const Icon(Icons.image),
          ),
            FloatingActionButton(
              backgroundColor: const Color(0xff064273),
              onPressed: () {
                pickImageC();
                uploadImage(context);
              },
              tooltip: "Pick Image from Camera",
              child:
              const Icon(Icons.camera_alt),
            ),
          ]
      ),
    );
  }

  // uploadImage() async {
  //   print ("uploadImage works");
  //   pickImageC();
  //   pickImage();
  //   final _firebaseStorage = FirebaseStorage.instance;
  //   // final _imagePicker = ImagePicker();
  //   // PickedFile image;
  //   //Check Permissions
  //   await Permission.photos.request();
  //
  //   var permissionStatus = await Permission.photos.status;
  //
  //   if (permissionStatus.isGranted){
  //     //Select Image
  //     //image = await _imagePicker.getImage(source: ImageSource.gallery);
  //     var file = File(image.path);
  //
  //     if (image != null){
  //       //Upload to Firebase
  //       var snapshot = await _firebaseStorage.ref()
  //           .child('images/imageName')
  //           .putFile(file); //.onComplete;
  //       var downloadUrl = await snapshot.ref.getDownloadURL();
  //       setState(() {
  //         imageUrl = 'gs://sih-clapforkrishna-c1752.appspot.com/recentUploads';
  //       });
  //     } else {
  //       print('No Image Path Received');
  //     }
  //   } else {
  //     print('Permission not granted. Try Again with permission access');
  //   }
  // }

  Future uploadImage(BuildContext context) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String url = "";
    Reference ref = storage.ref().child(temp['label']+ "_" + i);
    i++;
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.whenComplete(() {
      url = ref.getDownloadURL() as String;
    }).catchError((onError) {
      print(onError);
    });
    return url;
  }


  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position>_determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

// Future<void> GetAddressFromLatLong(Position position)async {
//   List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//   print(placemarks);
//   Placemark place = placemarks[0];
//   Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
//
// }
}