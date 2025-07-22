import 'package:flutter/material.dart'; // Flutter UI framework
import 'pages/splash.dart'; // splash screen page
import 'pages/signup.dart'; // signup page
import 'pages/login.dart'; // login page
import 'pages/homepage.dart'; // main home page after login/signup

void main() =>
    runApp(HairHouseApp()); // runs the app starting from HairHouseApp

class HairHouseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hair House', // app name

      // app theme setup (dark mode with custom primary color)
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF1C1C1C), // dark background
        primaryColor: Color(0xFFFFD700), // gold-like primary color
      ),

      debugShowCheckedModeBanner: false, // hides debug banner on top right

      initialRoute: '/', // sets the first page to show when app launches

      // defines app routes for navigation
      routes: {
        '/': (context) => SplashPage(),
        '/signup': (context) => SignupPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
