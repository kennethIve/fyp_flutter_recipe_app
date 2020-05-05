import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipe/com_var.dart' as com;
import 'word.dart'
as word;

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int _selectedIndex = 0;

  final options = [
    new DrawerItem("Search", Icons.fastfood),
    new DrawerItem("Favourite", Icons.local_pizza),
    new DrawerItem("Coffee", Icons.local_cafe)    
  ];

  _onSelectItem(int index) {
    setState(() {
      _selectedIndex = index;
      debugPrint('$_selectedIndex');
    });
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<ListTile> drawerOptions = [];
    for (var i = 0; i < options.length; i++) {
      var d = options[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(
          d.title,
          style: new TextStyle(fontSize: 15.0),
        ),
        selected: i == _selectedIndex,
        onTap: () => _onSelectItem(i),
      ));
    }
    return new Container(
      width: 250,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,        
          children: < Widget > [
            Container(
              height: 90.0,
              child: new DrawerHeader(
                child: word.drawerTitle(com.SideBarName),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
              ),
            ),
           Card(
              child: drawerOptions.first,                          
           ),
           Card(
              child: drawerOptions[1],                          
           ),
           Card(
              child: drawerOptions[2],                          
           ),
          ],
        ),
      )
    );
  }
}

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}