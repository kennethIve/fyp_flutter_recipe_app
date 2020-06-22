
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipe/com_var.dart' as com;
import 'package:recipe/screens/IngredientSearchPage.dart';
import 'package:recipe/screens/ListPage.dart';
import 'package:recipe/screens/SearchPage.dart';
import 'word.dart'
as word;

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  static int _selectedIndex = 0;

  //route
  final options = [
    new DrawerItem("Recipes", Icons.fastfood,MaterialPageRoute(builder: (context)=>ListPage())),
    new DrawerItem("Search", Icons.search,MaterialPageRoute(builder: (context)=>SearchPage())),
    new DrawerItem("Ingredient Search", Icons.shopping_basket,MaterialPageRoute(builder: (context)=>IngredientSearchPage()))
  ];

  void onSelectItem(int index) {
    setState(() {
      debugPrint('$_selectedIndex');                    
      Navigator.of(context).pop(); // close the drawer
      if(index == _selectedIndex)
        return;
      _selectedIndex = index;
      Navigator.pop(context);
      Navigator.push(context, options[_selectedIndex].page);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    //drawer header
    drawerOptions.add(Container(
        height: 90.0,
        child: new DrawerHeader(child: word.drawerTitle(com.sideBarName),decoration: BoxDecoration(color: com.defaultTheme.backgroundColor,),
        ),)
    );
    //loop create drawer option
    for (var i = 0; i < options.length; i++) {
      var d = options[i];      
      drawerOptions.add(Ink(
        color: (i == _selectedIndex)?Colors.lightGreen:null,
        child:ListTile(        
        leading: Icon(d.icon),
        title: Text(
          d.title,
          style: com.defaultTheme.textTheme.headline1,
        ),        
        selected: i == _selectedIndex,        
        onTap: () => onSelectItem(i),
      )));
    }

    return new Container(
      width: 250,
      child: Drawer(      
        child: ListView(
          padding: EdgeInsets.zero,        
          children: drawerOptions
        ),
      )
    );
  }
}

class DrawerItem {
  String title;
  IconData icon;
  var page;
  DrawerItem(this.title, this.icon,this.page);
}