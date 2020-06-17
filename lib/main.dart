import 'package:flutter/material.dart';
import './screens/ListPage.dart';
import 'com_var.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fyp temp',
      theme: defaultTheme,
      debugShowCheckedModeBanner: true,     
      home: ListPage(title: 'Recipes'),
      
    );
  }
}
