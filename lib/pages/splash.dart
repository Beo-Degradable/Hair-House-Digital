import 'package:flutter/material.dart'; // Flutter UI framework
import 'dart:async'; // for Timer

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // starts a 4-second timer then navigates to signup page
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/signup');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // makes child widgets fill entire screen
        children: [
          // background image
          Image.asset('images/splashbg.gif', fit: BoxFit.cover),

          // dark overlay for readability
          Container(color: Colors.black.withOpacity(0.5)),

          // app name and slogan centered
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hair House",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Your Style, Our Passion.",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          // linear progress indicator at bottom
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: LinearProgressIndicator(
              color: Colors.amber,
              backgroundColor: Colors.white24,
            ),
          ),
        ],
      ),
    );
  }
}
