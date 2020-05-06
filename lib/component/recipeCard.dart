import 'package:flutter/material.dart';
import 'package:recipe/model/recipeModel.dart';
import 'package:recipe/screens/home.dart';
import 'package:recipe/screens/recipeDetailPage.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({
    Key key,
    this.recipe
  }): super(key: key);
  //route to detail page
   showDetail(BuildContext context) async {
    print(recipe.name);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>RecipeDetailPage(recipe: this.recipe,)));
  }
  @override
  Widget build(BuildContext context) {
    return new Card(
          margin: EdgeInsets.symmetric(vertical:10.0,horizontal:30.0),
          child: new InkWell(
            onTap: (){showDetail(context);},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                img(),
                ListTile(
                  leading: Text(recipe.getDuration()+"Mins"),
                  title: Text(recipe.name),
                  subtitle: Text(recipe.description),
                ),
                ButtonBar(
                  children: <Widget>[
                    // FlatButton(
                    //   child: const Text('Detail'),
                    //   onPressed: () { /* ... */ },
                    // ),
                  ],
                ),
              ],
            ),
          )
        );
  }
  //image widget
  Widget img(){
    return Padding(
      padding: EdgeInsets.all(15),
      child:AspectRatio(      
        aspectRatio: 16.0 / 9.0,
        child: Image.network(
          
          recipe.imgUrl,
          fit: BoxFit.cover,                
        ),
      )
    );
  }
  //card detail widget
  Widget title(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        // Default value for crossAxisAlignment is CrossAxisAlignment.center.
        // We want to align title and description of recipes left:
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            recipe.name,
            style: Theme.of(context).textTheme.title,
          ),
          // Empty space:
          SizedBox(height: 10.0),
          Row(
            children: [
              Icon(Icons.timer, size: 20.0),
              SizedBox(width: 5.0),
              Text(
                recipe.getDuration(),
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
