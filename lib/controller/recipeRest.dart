library restcall;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:recipe/model/recipeModel.dart';

class RecipeRest{

  static Dio dio = new Dio();
  static String url = "http://104.154.239.168/api";
  static String token = "t1TkHac7Tugi4mY7u6lxyYKgp4uz8w34KRLY2Dgi";

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

  void dioAuth(){
      dio.options.headers["Content-Type"] = Headers.jsonContentType;
      dio.options.headers["X-Requested-With"] = "XMLHttpRequest";
      dio.options.headers["Authorization"] = token;
  }
  Future<List<Recipe>> getAllRecipes({int range = 2}) async {
    try {
      dioAuth();      
      Response response = await dio.get(url+"/details");//testing api
      List<Recipe> temp = recipes.sublist(0,range);
      debugPrint("RestCall --getAllRecipes-- Status Code: "+response.statusCode.toString());
      debugPrint("RestCall --getAllRecipes-- Status Code: "+response.data["request"].toString());
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
      List<Recipe> temp = recipes.sublist(index,index+5);         
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