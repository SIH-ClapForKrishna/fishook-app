import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'login_screen.dart';


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
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ));
        })),
    );
  }
}