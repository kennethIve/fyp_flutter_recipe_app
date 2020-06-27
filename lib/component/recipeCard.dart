import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/model/recipeModel.dart';
import 'package:recipe/screens/recipeDetailPage.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  static const double iconSize = 13;
  static const List<Widget> levels = [
    Icon(Icons.looks_one,size: iconSize,color: Colors.grey,),
    Icon(Icons.looks_two,size: iconSize,color: Colors.grey,),
    Icon(Icons.looks_3,size: iconSize,color: Colors.grey,),
    Icon(Icons.looks_4,size: iconSize,color: Colors.grey,),
    Icon(Icons.looks_5,size: iconSize,color: Colors.grey,),
    Icon(Icons.looks_6,size: iconSize,color: Colors.grey,),    
  ];

  const RecipeCard({
    Key key,
    this.recipe
  }): super(key: key);
  //route to detail page
  showDetail(BuildContext context) async {
    print(recipe.title);
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>RecipeDetailPage(recipe: this.recipe,)));
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>
  }
  
  
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        openElevation: 200,
        closedColor: Colors.transparent,
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback openContainer) {
          return RecipeDetailPage(recipe: this.recipe,);
        },
        closedElevation: 10.0,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return  Card(
            margin: EdgeInsets.symmetric(vertical:5.0,horizontal:20.0),              
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 0.0),child: block(),),
                        
        );
        },
      );
  }
  //recipe widget
  Widget block(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,      
      children: <Widget>[        
        ClipRRect(
          //padding: EdgeInsets.only(top:10),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),topRight: Radius.circular(5.0),),
          child: Image.network(recipe.image,            
            //height: 200,
            //width: 300,
            fit: BoxFit.cover,
            loadingBuilder: (context,child,progress){
            if (progress == null) return child; 
              return Center(
                child: CircularProgressIndicator(value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes : null,),);
                },
          ),
        ),
        ExpansionTile(
          title: Text(recipe.title,style: GoogleFonts.notoSerif(textStyle: TextStyle(fontStyle: FontStyle.italic,fontSize: 15,fontWeight: FontWeight.bold,)),textAlign: TextAlign.start,softWrap: true,),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            
            children:[
              SmoothStarRating(starCount: 5,rating: recipe.getRating(),isReadOnly: true,size: 13,color: Colors.orange,),
              time(),
              skillTerm(),
            ]
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
              child: desc(),
            ),
          ],
        ),
        
      ],
    );
  }
  Widget time(){
    return 
      Container(
        child: Row(
          children: [Icon(Icons.timer,size: 13,color: Colors.grey,),
            Text(recipe.getDuration(),style:TextStyle(fontSize:13,fontFamily: "Serif")),
            Text(" mins",style:TextStyle(fontSize:13,fontFamily: "Serif")),                    
        ]),
      );
  }
  Widget skillTerm(){
    return 
      Container(
        child: Row(
          children: [
            Text("Level:",style:TextStyle(fontSize:13,fontFamily: "Serif")),
            levels[recipe.skillTerm],
        ]),
      );
  }
  Widget desc(){
    return Text(
      recipe.description,
      style: TextStyle(
        fontSize: 12,color: Colors.black45
      ),
    );
  }
  //image widget
  Widget img(){
    return Padding(
      padding: EdgeInsets.all(10),
      child:AspectRatio(      
        aspectRatio: 1.0 / 2.0,
        child: Image.network(          
          recipe.image,
          fit: BoxFit.cover,          
        ),
      )
    );
  }
  
}
