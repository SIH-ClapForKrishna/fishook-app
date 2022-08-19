import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sih_fishook/navbar.dart';

import 'login_screen.dart';
import 'home_screen.dart';


class LoginAnimations extends StatefulWidget {
  const LoginAnimations({Key? key}) : super(key: key);

  @override
  State<LoginAnimations> createState() => _LoginAnimationsState();
}

class _LoginAnimationsState extends State<LoginAnimations> with SingleTickerProviderStateMixin{
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold (
      body: Center(child: Lottie.asset('assets/95019-fishing-bye-bye.json', controller: _controller,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            ..forward().whenComplete(() => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong!'));
                    } else if (snapshot.hasData) {
                      return const NavBar() ;
                    } else {
                      return const LoginScreen();
                  }}),
            )));
        })),
    );
  }
}