library model;
import 'dart:core';

import 'package:flutter/foundation.dart';

//data model for a recipe 
class Recipe{
  int recipeId;//recipe name

  String title;//recipe name

  int cookTime = 10;

  int rating = 3;

  int skillTerm = 3;

  String description; //recipe description

  List<String>steps; //recipe steps

  List<Ingredient>ingredients = []; //recipe ingredients

  String image = 'https://www.bbcgoodfood.com/sites/default/files/recipe-collections/collection-image/2013/05/chorizo-mozarella-gnocchi-bake-cropped.jpg';

  String dietTerm;

  String resoureceUrl;

  Recipe(this.recipeId,this.title,this.description,this.image,this.rating,this.skillTerm,this.cookTime,this.dietTerm,this.resoureceUrl);
  
  Recipe.empty();
  
  String getDuration(){
    //return (cookTime/60).toString();
    var duration = (cookTime/60).round();
    if(duration < 10)
      return " < 10";
    else if(duration > 240)
      return " > 240";
    return duration.toString();
  }

  getRating() {
    return rating.toDouble();
  }

  factory Recipe.fromJson(Map<String,dynamic> recipe)
  {
    return Recipe(
      recipe["recipe_id"],
      recipe["title"],
      recipe["description"],
      recipe["image"],
      recipe["rating"],
      recipe["skill_term"],
      recipe["cook_time"],
      recipe["diet_term"],
      recipe["resource_url"]
    );
  }  
}

class Ingredient {
  int recipeIngredientsId;
  int recipeId;
  int sequence;
  String content;

  Ingredient(
      {this.recipeIngredientsId, this.recipeId, this.sequence, this.content});

  Ingredient.fromJson(Map<String, dynamic> json) {
    recipeIngredientsId = json['recipe_ingredients_id'];
    recipeId = json['recipe_id'];
    sequence = json['sequence'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipe_ingredients_id'] = this.recipeIngredientsId;
    data['recipe_id'] = this.recipeId;
    data['sequence'] = this.sequence;
    data['content'] = this.content;
    return data;
  }
}