
import 'package:sih_fishook/search__page.dart';

import 'home_screen.dart';
import 'settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);


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

  int _selectedIndex=0;
  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  final screens = [
    const HomePage(),
    const SearchPage(),
    SettingsPage(),
    //const HomePage(),
  ];

  int index =0;

  @override
  Widget build(BuildContext context){
    final items =<Widget>[
      const Icon(Icons.home,size:30),
      const Icon(Icons.search,size:30),
      const Icon(Icons.person,size:30),
      //const Icon(Icons.person,size:30),
    ];
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      //backgroundColor: const Color(0xff064273),
      //appBar: AppBar(title: const Text(_title)),
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.white),
        ),
        child:CurvedNavigationBar(
          color: Color(0xff064273),
        key: navigationKey,
        buttonBackgroundColor: Color(0xff064273),
        backgroundColor: Colors.transparent,
        height: 50,
        index: index,
        items: items,
        onTap: (index) => setState(() => this.index =index),
      ),
      ),
      );
  }

}



