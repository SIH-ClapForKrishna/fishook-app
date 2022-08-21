

import 'dart:io';
import 'settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String _title = 'Welcome, User';

  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(title: const Text(_title)),
      body: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  late File _image;
  late List _results;
  bool imageSelect=false;
  @override
  void initState()
  {
    super.initState();
    loadModel();
  }
  Future loadModel()
  async {
    Tflite.close();
    String res;
    res=(await Tflite.loadModel(model: "assets/fishClassifier.tflite",labels: "assets/fishClassifier.txt"))!;
    print("Models loading status: $res");
  }

  Future imageClassification(File image)
  async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results=recognitions!;
      _image=image;
      imageSelect=true;
    });
  }

  Future pickImage()
  async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image=File(pickedFile!.path);
    imageClassification(image);
  }

  Future pickImageC()
  async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    File image=File(pickedFile!.path);
    imageClassification(image);
  }


  @override
  Widget build(BuildContext context){
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
              (imageSelect)?Container(
                margin: const EdgeInsets.all(10),
                child: Image.file(_image),
              ):Container(
                margin: const EdgeInsets.all(10),
                child: const Opacity(
                  opacity: 1,
                  child: Center(
                    child: Text("No image selected"),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: (imageSelect)?_results.map((result) {
                    return Card(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Text(
                          "${result['label']} - ${result['confidence'].toStringAsFixed(2)}",
                          style: const TextStyle(color: const Color(0xff064273),
                              fontSize: 18),
                        ),
                      ),
                    );
                  }).toList():[],

                ),
              ),
            ],
          )
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
      children: [ FloatingActionButton(
        backgroundColor: const Color(0xff064273),
        onPressed: pickImage,
        tooltip: "Pick Image",
        child: const Icon(Icons.image),
      ),
        FloatingActionButton(
          backgroundColor: const Color(0xff064273),
          onPressed: pickImageC,
          tooltip: "Pick Image",
          child: const Icon(Icons.camera_alt),
        ),
      ]
      ),
    );
  }

}



