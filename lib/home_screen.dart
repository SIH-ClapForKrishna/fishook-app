import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String _title = 'Home Page';

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: const Text('Logged In Successfully'),
    );
  }
}