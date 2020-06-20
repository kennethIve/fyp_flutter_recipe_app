library restcall;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:recipe/model/recipeModel.dart';

class RecipeRest{

  static Dio dio = new Dio();
  //static String url = "http://104.154.239.168/api";
  static String url = "http://192.168.1.99/api";
  static String token = "t1TkHac7Tugi4mY7u6lxyYKgp4uz8w34KRLY2Dgi";

  static List<Recipe>recipes = [];
  RecipeRest();

  void dioAuth(){
      dio.options.baseUrl = url;
      dio.options.connectTimeout =15000;
      dio.options.receiveTimeout = 10000;
      dio.options.headers["Content-Type"] = 'application/json';
      dio.options.headers["Authorization"] = token;
  }
  Future<List<Recipe>> getAllRecipes({int range = 5,int start = 0}) async {
    try {
      dioAuth();
      Map<String, dynamic> data={"start":start,"take":range};
      Response response = await dio.get("/getRecipes",queryParameters: data);//testing api
      //Response response = await dio.get("http://www.google.com");
      List<Recipe> result =[];
      for(var recipe in response.data){
        result.add(new Recipe(
          recipe["recipe_id"],recipe["title"],recipe["description"],recipe["image"],
          recipe["rating"],recipe["skill_term"],recipe["cook_time"],recipe["diet_term"],recipe["resource_url"],
        ));
      }
      return result; 
    } on DioError catch(e) {
        if(e.response != null) {
            print(e.response.data);
            print(e.response.headers);
            print(e.response.request);
        } else{
            print(e.request);
            print(e);
        }    
      return [];
    }catch(e){
      print(e);
      return [];
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
        if(recipe.title.contains(keyword))
          temp.add(recipe);
      });      
      return temp; 
    } catch (e) {
      debugPrint(e);      
      return recipes;
    }
      
  }

}