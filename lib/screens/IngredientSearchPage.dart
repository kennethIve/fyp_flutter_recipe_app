import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:recipe/com_var.dart';
import 'package:recipe/component/drawer.dart';
import 'package:recipe/model/recipeModel.dart';

import 'ObjectDetectPage.dart';


class IngredientSearchPage extends StatelessWidget {
  
  const IngredientSearchPage({Key key, this.title, this.recipe}) : super(key: key);
  final String title;
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: topBar(),
          drawer: SideBar(),
          bottomNavigationBar: BottomAppBar(
            child: IconButton(
              icon: Icon(Icons.search), 
              onPressed: () async {
                List<CameraDescription> cameras = await availableCameras();
                Future.delayed(Duration(seconds:2)).then((value) => {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ObjectDetectPage(cameras: cameras,)))
                });                
              }
            ),
          ),
          backgroundColor: null,//Color.fromRGBO(58, 66, 86, 1.0),
          body: Container(
            child:Text("Ingredient Search Page",style: TextStyle(color: Colors.black,fontSize: 20.0),)
            ),
        )
    );
  }
} 