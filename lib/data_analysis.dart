
import 'package:flutter/material.dart';

class DataAnalysis extends StatelessWidget {
  const DataAnalysis({Key? key}) : super(key: key);


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
  static const String _title = 'Market Analysis';

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text(_title),),
      body: Column(
          children: <Widget>[
            Image.asset(
                'assets/hyd0.png', width: 1000,
                height: 500),
    ],
      ),
    );

  }

}



