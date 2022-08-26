
import 'home_screen.dart';
import 'settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context){
    return const Scaffold(

      //appBar: AppBar(title: const Text(_title)),
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
  static const String _title = 'Search';
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text(_title),),
      body: const Align(
        alignment: Alignment.center,
        child: Text("Coming Soon!",
        style: TextStyle(fontSize: 30,color: Colors.red),
      ),
      ),
      );
  }

}



