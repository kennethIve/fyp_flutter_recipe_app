library my_lib.globals;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//global variable
String appName = 'Recipe';

String sideBarName = 'Options';

//common widgets
topBar({String type,String title,Future<dynamic> search(),Color color}){
  if(type == "listPage"){
    return AppBar(
          elevation: 0.5,
          backgroundColor: Color.fromRGBO(95, 144, 148, 0.9),
          title: Text(appName),          
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: search,
            )
          ],
        );
  }else if(type == "custom"){
    return AppBar(
        elevation: 0.5,
        backgroundColor: color != null?color:Color.fromRGBO(95, 144, 148, 0.9),        
        title:Text(title),          
        centerTitle: true,
        actions: <Widget>[
        ],
      );
  }
  return AppBar(
        elevation: 0.5,
        backgroundColor: Color.fromRGBO(95, 144, 148, 0.9),
        title:Text(appName),          
        centerTitle: true,
        actions: <Widget>[
        ],
      );
  
}

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

ThemeData defaultTheme 
= new ThemeData(
  brightness: Brightness.light,
  primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
  fontFamily: 'Georgia',
);

//fillter dialogg

void showfilterModal(BuildContext context) async{
  TextStyle mystyle = TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0);
  ShapeBorder shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0));
  Dialog dialog = Dialog(
    //backgroundColor: Colors.yellow[50],
    shape: shape,
    insetPadding: EdgeInsets.fromLTRB(5, 5, 5, 0),        
    child: Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * .5,
      width: MediaQuery.of(context).size.width * .6,
      child: Column(                
        children: <Widget>[
          Expanded(
            child: Wrap(),
          ),
          Expanded(
            child: Wrap(),
          ),
         Flex(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,            
            direction: Axis.horizontal,
            children:[
              Expanded(
                child: FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Cancel",style: mystyle,),),
              ),
              Expanded(
                child: FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Apply", style: mystyle,),),
              ),
          ]
            )
          
        ],        
      )
    ),
  );
  showDialog(context: context,builder: (BuildContext context) => dialog);
}