library restcall;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:recipe/model/recipeModel.dart';

class RecipeRest{

  static Dio dio = new Dio();
  static String url = "http://104.154.239.168/api";
  //static String url = "http://192.168.1.99/api";
  static String token = "t1TkHac7Tugi4mY7u6lxyYKgp4uz8w34KRLY2Dgi";

  List<Recipe>recipes = [];
  RecipeRest();

  void dioAuth({bool needAuth = false}){
      dio.options.baseUrl = url;
      dio.options.connectTimeout =15000;
      dio.options.receiveTimeout = 10000;
      dio.options.headers["Content-Type"] = 'application/json';
      if (needAuth) {        
        dio.options.headers["Authorization"] = token;  
      }else{
        dio.options.headers["Authorization"] = "";  
      }
  }
  //common function to change json to recipe model
  List<Recipe> _reponseToRecipe(Response response)
  {
    List<Recipe> result =[];
    for(var recipe in response.data)
    {
      Recipe temp = new Recipe(
        recipe["recipe_id"],recipe["title"],recipe["description"],recipe["image"],
        recipe["rating"],recipe["skill_term"],recipe["cook_time"],recipe["diet_term"],recipe["resource_url"],
      );
      for(var ingredient in recipe["ingredients"])
      {
        temp.ingredients.add(Ingredient.fromJson(ingredient));
      }
      for(var step in recipe["steps"])
      {
        temp.steps.add(Steps.fromJson(step));
      }
      result.add(temp);
    }    
    return result;
  }
  //mainly for list page  
  Future<List<Recipe>> getAllRecipes({int range = 5,int start = 0, List orderBy = const [], List order = const [] }) async {
    try {
      dioAuth(needAuth: true);
      Map<String, dynamic> data={"start":start,"take":range,"orderBy":orderBy,"order":order};
      print(data);
      Response response = await dio.get("/getRecipes",queryParameters: data);//testing api
      //Response response = await dio.get("http://www.google.com");
      List<Recipe> result = _reponseToRecipe(response);
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
  //get recipe by title --->for search delegate user
  Future<List<Recipe>> getRecipeByKeyword(String keyword,{int take=10}) async {
    if(keyword.isEmpty || keyword.length < 2)
      return[];
    try {
      dioAuth();
      Response response = await dio.get("/getRecipesByName",queryParameters:{"words":keyword,"take":take});      
      //debugPrint("RestCall --getRecipeByKeyword-- keyword:'$keyword' Status Code: "+response.statusCode.toString());
      //for testing
      List<Recipe> temp = _reponseToRecipe(response);
      return temp; 
    } catch (e) {
      debugPrint(e);      
      return recipes;
    }
      
  }

}