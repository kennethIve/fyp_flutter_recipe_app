library styling;

import 'package:flutter/material.dart';
import 'package:recipe/com_var.dart';
//style function
Text drawerOption(String words){
  return Text(words,style:TextStyle(height: 1,fontSize: 15));
}
Text drawerTitle(String words){
  return Text(words,
  style:TextStyle(
    height:1,fontSize: 25,color: defaultTheme.iconTheme.color,fontWeight: FontWeight.bold 
    ));
}