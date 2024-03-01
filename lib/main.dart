import 'package:flutter/material.dart';
import 'package:storing_application/Screens/homescreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storing Application',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}