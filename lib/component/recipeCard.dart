import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>RecipeDetailPage(recipe: this.recipe,)));
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>
  }
  
  @override
  Widget build(BuildContext context) {
    // return Container(
    //         height: 150,            
    //         child: Card(
    //           margin: EdgeInsets.symmetric(vertical:2.0,horizontal:10.0),
    //           //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),              
    //           child: new InkWell(                            
    //             onTap: (){showDetail(context);},            
    //             child: Padding(padding: EdgeInsets.all(10),child: block(),)                
    //           )              
    //         )
    //     );
    return OpenContainer(
        openElevation: 200,
        closedColor: Colors.transparent,
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback openContainer) {
          return RecipeDetailPage(recipe: this.recipe,);
        },
        closedElevation: 10.0,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return Container(
            height: 150,            
            child: Card(
              margin: EdgeInsets.symmetric(vertical:2.0,horizontal:10.0),
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),              
              child: Padding(padding: EdgeInsets.all(10),child: block(),)            
            )
        );
        },
      );
  }
  //recipe widget
  Widget block(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(          
          child: Image.network(recipe.imgUrl,fit: BoxFit.fitHeight,loadingBuilder: (context,child,progress){
                    if (progress == null) return child; 
                    return Center(
                      child: CircularProgressIndicator(value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes : null,),);
                    },
                    ),
        ),
        Expanded(
          child: desc(),
        )
      ],
    );
  }
  Widget desc(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [        
        Container(
          child:Text(recipe.name,style: GoogleFonts.notoSerif(textStyle: TextStyle(fontSize: 20)),textAlign: TextAlign.start,)
        ),
        Container(        
          child:SmoothStarRating(starCount: 5,rating: recipe.rating,isReadOnly: true,size: 20,)
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
            Icon(Icons.favorite,size: 18),
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
        aspectRatio: 1.0 / 2.0,
        child: Image.network(          
          recipe.imgUrl,
          fit: BoxFit.cover,          
        ),
      )
    );
  }
  
}
