library restcall;
import 'dart:core';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:recipe/model/recipeModel.dart';

class RecipeRest{
  static Dio dio = new Dio();
  final List<Recipe>recipes = [
      Recipe('r456', 'description 1', ['steps 1','steps 2']),
      Recipe('r2', 'description 1', ['steps 1','steps 2']),
      Recipe('r1', 'description 1', ['steps 1','steps 2']),
      Recipe('r1', 'description 1', ['steps 1','steps 2']),
      Recipe('r1', 'description 1', ['steps 1','steps 2']),
      Recipe('r1', 'description 1', ['steps 1','steps 2']),
      Recipe('r1', 'description 1', ['steps 1','steps 2']),
      Recipe('rend-1', 'description 1', ['steps 1','steps 2']),
      Recipe('rend', 'description 2', ['steps 1','steps 2'])
    ];

  Future<List<Recipe>> getAllRecipes({int range = 2}) async {
    try {
      Response response = await dio.get("http://www.google.com");
      List<Recipe> temp = recipes.sublist(0,range);
      debugPrint("RestCall Status Code: "+response.statusCode.toString());
      return temp; 
    } catch (e) {
      debugPrint(e);      
      return recipes;
    }
      
    }
  Future<List<Recipe>> getNextSetRecips({index:int}) async {
    try {
      Response response = await dio.get("http://www.google.com");
      List<Recipe> temp = recipes.sublist(index,index+1);         
      return temp; 
    } catch (e) {
      print(e);      
      return [];
    }
      
    }
}