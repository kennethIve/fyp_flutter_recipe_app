library model;
import 'dart:core';

//data model for a recipe 
class Recipe{
  int recipeId;//recipe name

  String title;//recipe name

  int cookTime = 10;

  int rating = 3;

  int skillTerm = 3;

  String description; //recipe description

  List<String>steps; //recipe steps

  List<String>ingredients; //recipe ingredients

  String image = 'https://www.bbcgoodfood.com/sites/default/files/recipe-collections/collection-image/2013/05/chorizo-mozarella-gnocchi-bake-cropped.jpg';

  String dietTerm;

  String resoureceUrl;

  Recipe(this.recipeId,this.title,this.description,this.image,this.rating,this.skillTerm,this.cookTime,this.dietTerm,this.resoureceUrl);

  Recipe.empty();
  
  String getDuration(){
    return (cookTime/60).toString();
  }

  getRating() {
    return rating.toDouble();
  }
}