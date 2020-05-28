library restcall;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:recipe/model/recipeModel.dart';

class RecipeRest{

  static Dio dio = new Dio();

  List<Recipe>recipes = [
      Recipe('r456', 'description 1', ['steps 1','steps 2']),
      Recipe('r2', 'description 1', ['steps 1','steps 2']),
      Recipe('r1', 'description 1', ['steps 1','steps 2']),
      Recipe('r1', 'description 1', ['steps 1','steps 2']),
      Recipe('r1', 'description 1', ['steps 1','steps 2']),
      Recipe('r1', 'description 1', ['steps 1','steps 2']),
      Recipe('r1', 'description 1', ['steps 1','steps 2']),
      Recipe('kenneth', 'description 1', ['steps 1','steps 2']),
      Recipe('rend-4', 'description 1', ['steps 1','steps 2']),
      Recipe('rend-3', 'description 1', ['steps 1','steps 2']),
      Recipe('rend-2', 'description 1', ['steps 1','steps 2']),
      Recipe('rend-1', 'description 1', ['steps 1','steps 2']),
      Recipe('rend', 'description 2', ['steps 1','steps 2']),
      Recipe('kenneth', 'description 1', ['steps 1','steps 2']),
      Recipe('rend-4', 'description 1', ['steps 1','steps 2']),
      Recipe('rend-3', 'description 1', ['steps 1','steps 2']),
      Recipe('rend-2', 'description 1', ['steps 1','steps 2']),
      Recipe('rend-1', 'description 1', ['steps 1','steps 2']),
      Recipe('rend', 'description 2', ['steps 1','steps 2']),
      Recipe('kenneth', 'description 1', ['steps 1','steps 2']),
      Recipe('rend-4', 'description 1', ['steps 1','steps 2']),
      Recipe('rend-3', 'description 1', ['steps 1','steps 2']),
      Recipe('rend-2', 'description 1', ['steps 1','steps 2']),
      Recipe('rend-1', 'description 1', ['steps 1','steps 2']),
      Recipe('rend', 'description 2', ['steps 1','steps 2'])
  ];
  RecipeRest();

  Future<List<Recipe>> getAllRecipes({int range = 2}) async {
    try {
      Response response = await dio.get("http://www.google.com");
      List<Recipe> temp = recipes.sublist(0,range);
      debugPrint("RestCall --getAllRecipes-- Status Code: "+response.statusCode.toString());
      return temp; 
    } catch (e) {
      debugPrint(e);      
      return recipes;
    }
      
  }

   Future<List<Recipe>> getNextSetRecips({index:int}) async {
    try {
      Response response = await dio.get("http://www.google.com");
      response.toString();
      List<Recipe> temp = recipes.sublist(index,index+3);         
      return temp; 
    } catch (e) {
      print(e);      
      return [];
    }
  }

  Future<List<Recipe>> getRecipeByKeyword(String keyword) async {
    if(keyword.isEmpty)
      return[];
    try {      
      Response response = await dio.get("http://www.google.com",queryParameters:{"keyword":keyword});      
      debugPrint("RestCall --getRecipeByKeyword-- keyword:$keyword Status Code: "+response.statusCode.toString());
      //for testing
      List<Recipe> temp = [];
      recipes.forEach((recipe){
        if(recipe.name.contains(keyword))
          temp.add(recipe);
      });      
      return temp; 
    } catch (e) {
      debugPrint(e);      
      return recipes;
    }
      
  }

}