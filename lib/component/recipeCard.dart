import 'package:flutter/material.dart';
import 'package:recipe/model/recipeModel.dart';
import 'package:recipe/screens/recipeDetailPage.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

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
    return Container(
            height: 200,            
            child: Card(
              margin: EdgeInsets.symmetric(vertical:2.0,horizontal:10.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),              
              child: new InkWell(            
                onTap: (){showDetail(context);},            
                child: Padding(padding: EdgeInsets.all(10),child: block(),)
              )
            )
        );
  }
  //old
  Widget oldBlock(){
    return Column(
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
            );
  }
  

  //recipe widget
  Widget block(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 180,
          width: 180,
          child: Image.network(recipe.imgUrl,fit: BoxFit.cover,loadingBuilder: (context,child,progress){
                    if (progress == null) return child; 
                    return Center(
                      child: CircularProgressIndicator(value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes : null,),);
                    },
                    ),
        ),        
        desc(),        
      ],
    );
  }
  Widget desc(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [        
        Container(
          child:Text(recipe.name,style: TextStyle(fontSize: 25,fontFamily:"Serif"),textAlign: TextAlign.start,)
        ),
        Container(        
          child:SmoothStarRating(starCount: 5,rating: recipe.rating,isReadOnly: true,)
        ),
        Container(
          child: Row(children: [
            Icon(Icons.timer,semanticLabel: "hello world",size: 18,),
            Text(
              recipe.duration.toString(),style:TextStyle(fontSize:15,fontFamily: "Serif")
            ),
            Text(
              " Mins",style:TextStyle(fontSize:15,fontFamily: "Serif")
            ),
          ]),
        ),
      ],
      );
  }
  //image widget
  Widget img(){
    return Padding(
      padding: EdgeInsets.all(10),
      child:AspectRatio(      
        aspectRatio: 19.0 / 8.0,
        child: Image.network(          
          recipe.imgUrl,
          fit: BoxFit.cover,          
        ),
      )
    );
  }
  
}
