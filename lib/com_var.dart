library my_lib.globals;

import 'package:flutter/material.dart';
//global variable
String AppName = 'Recipe';

String SideBarName = 'Options';

//common widgets
Widget topBar = AppBar(
          elevation: 0.1,
          backgroundColor: Color.fromRGBO(95, 144, 148, 0.9),
          title: Center(child: Text(AppName)),          
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
              },
            )
          ],
        );

Widget botBar = Container(
          height: 55.0,
          child: BottomAppBar(
            color: Color.fromRGBO(58, 66, 86, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.blur_on, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.hotel, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.account_box, color: Colors.white),
                  onPressed: () {},
                )
              ],
            ),
          ),
        );