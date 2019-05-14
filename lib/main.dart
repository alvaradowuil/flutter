// main.dart

import 'package:flutter/material.dart';


import './LoginPage.dart';
import './HomePage.dart';

void main() {
  runApp(Principal());
}

String username;

class Principal extends StatelessWidget {

  final routes = <String, WidgetBuilder> {
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),

  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      routes: routes,
      title: 'Pedidos',
      theme: new ThemeData(          // Add the 3 lines from here... 
        primaryColor: Colors.white,
      ), 
    );
  }
}

