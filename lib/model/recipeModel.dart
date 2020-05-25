library model;
import 'dart:core';

//data model for a recipe 
class Recipe{
  String name;//recipe name

  double duration = 10;

  double rating = 3;

  String description; //recipe description

  List<String>steps; //recipe steps

  String imgUrl = 'https://www.bbcgoodfood.com/sites/default/files/recipe-collections/collection-image/2013/05/chorizo-mozarella-gnocchi-bake-cropped.jpg';

  Recipe(this.name,this.description,this.steps);

  Recipe.empty();
  
  String getDuration(){
    return duration.toString();
  }
}