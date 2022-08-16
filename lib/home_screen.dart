

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tflite/tflite.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String _title = 'Home Page';

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

  late double _imageWidth;
  late double _imageHeight;
  bool _busy = false;

  late List _recognitions;


  late File image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      predictImage(image);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _busy = true;
    loadModel().then((val){
      setState(() {
        _busy = false;
      });
    });
  }

  loadModel() async {
    Tflite.close();
    try {
      String? res = await Tflite.loadModel(
          model: "assets/mobilenet_v1_1.0_224.tflite",
          labels: "assets/mobilenet_v1_1.0_224.txt",
          numThreads: 1,
          // defaults to 1
          isAsset: true,
          // defaults to true, set to false to load resources outside assets
          useGpuDelegate: false // defaults to false, set to true to use GPU delegate
      );
      print (res);
    }on PlatformException{
      print ("Failed to load the model");
    }
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    await Tflite.close();
  }

  predictImage (image) async{
    await mobilenet(image);

    FileImage(image)
        .resolve(const ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
      setState (() {
        _imageWidth = info.image.width.toDouble();
        _imageHeight = info.image.height.toDouble();
      });
    })));

    setState((){
      image = image;
      _busy = false;
    });
  }

  mobilenet (File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      model: "Fish Detection",
      threshold: 0.3,
      imageMean: 0.0,
      imageStd: 255.0,
      numResultsPerClass: 1
    );

    setState(() {
      _recognitions = _recognitions;
    });
  }

  List<Widget> renderBoxes (Size screen) {
    if (_recognitions == null) return [];
    if (_imageWidth == null || _imageHeight == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight/_imageHeight*screen.width;

    Color blue = Colors.blue;

    return _recognitions.map((re){
      return Positioned(
      left: re["rect"]["x"]*factorX,
      top: re["rect"]["y"]*factorY,
      width: re["rect"]["w"]*factorX,
      height: re["rect"]["h"]*factorY,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
          color: blue,
          width: 3,
        )),
        child: Text(
          "${re["detectedClass"]} ${(re["confidenceInClass"]*100).toStringAsFixed(0)}",
        style: TextStyle(
          background: Paint()..color=blue,
          color: Colors.white,
          fontSize: 15,
        ),
      ),
      ) ,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context){
    
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

    stackChildren.add(Positioned(
      top: 0.0,
      left: 0.0,
      width: size.width,
      child: image == null? Text("No Image Selected"): Image.file(image),
    ));

    stackChildren.addAll(renderBoxes(size));

    if (_busy){
      stackChildren.add(const Center(child: CircularProgressIndicator(),
      ));
    }
    final user = FirebaseAuth.instance.currentUser!;
    return  Scaffold(
      //appBar: AppBar(title: const Text(_title)),
      body:
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Stack(
            children: stackChildren,
            ),
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
                  },
              ),
              const SizedBox(height: 40),
              image != null? Image.file(image!,height: 250,width: 250,): const Text('No Image Selected'),
              const Text(
                'Signed In as',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                user.email!,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(Icons.arrow_back, size: 32),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
            ],
          ),
      ),

    );
  }

}



