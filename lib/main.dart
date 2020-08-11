import 'package:flutter/material.dart';
import 'package:pesiapp/Screens/chatrooms.dart';
import 'package:pesiapp/common.dart';
import 'package:pesiapp/helper/authenticate.dart';
import 'package:pesiapp/helper/helper_functions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat',
      theme: ThemeData(
        scaffoldBackgroundColor: scaffoldColor,
        fontFamily: 'Comfortaa',
      ),
      home: userIsLoggedIn != null ? userIsLoggedIn ? ChatRoom() : Authenticate() : Authenticate(),
    );
  }
}
