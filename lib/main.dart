import 'package:flutter/material.dart';
import 'package:test_task/screens/component/bottom_navigation.dart';
import 'package:test_task/screens/create_screen.dart';
import 'package:test_task/screens/profile_view.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor:Color.fromARGB(247,248,250,255),
      ),
      home:CurvedBottomNavigation(),
      // home:  ProfileScreen(isOwnProfile: true,),
    );
  }


}