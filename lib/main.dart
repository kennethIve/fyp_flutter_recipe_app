import 'package:flutter/material.dart';
import "package:recipe/com_var.dart" as common;
import './screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fyp temp',
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
      debugShowCheckedModeBanner: true,     
      home: ListPage(title: 'Recipes'),      
    );
  }
}
