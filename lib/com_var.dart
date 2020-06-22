library my_lib.globals;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//global variable
String appName = 'Recipe';
Color commonBackground = Colors.orange[50];
ThemeData defaultTheme 
= ThemeData(
  brightness: Brightness.light,
  backgroundColor: Color.fromRGBO(95, 144, 148, 0.9),//color like appbar
  primaryColor: Color.fromRGBO(58, 66, 86, 1.0), //
  iconTheme: IconThemeData(color: Colors.white),
  textTheme: TextTheme(
    headline6: TextStyle(color:Colors.white,fontSize: 18,fontFamily: 'Georgia'),
    bodyText2: TextStyle(color:Colors.black87,),
  ),
  primaryTextTheme: TextTheme(    
    headline1: TextStyle(color:Colors.red,fontSize: 18,fontFamily: 'Georgia'),
    headline6: TextStyle(color:Colors.black,fontSize: 18,fontFamily: 'Georgia'),
  ),
  fontFamily: 'Georgia',
);

//common widgets
String sideBarName = 'Options';

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

//fillter dialogg
topBar({String type,String title,Future<dynamic> search(),Color color}){
  if(type == "listPage"){
    return AppBar(
          elevation: 0.5,
          backgroundColor: defaultTheme.backgroundColor,
          iconTheme: defaultTheme.iconTheme,
          textTheme: defaultTheme.textTheme,
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
        backgroundColor: color != null?color:defaultTheme.backgroundColor,
        iconTheme: defaultTheme.iconTheme,
        textTheme: defaultTheme.textTheme,       
        title:Text(title),          
        centerTitle: true,
        actions: <Widget>[
        ],
      );
  }
  return AppBar(
        elevation: 0.5,
        backgroundColor: color != null?color:defaultTheme.backgroundColor,
        iconTheme: defaultTheme.iconTheme,
        textTheme: defaultTheme.textTheme, 
        title:Text(appName),          
        centerTitle: true,
        actions: <Widget>[
        ],
      );
  
}