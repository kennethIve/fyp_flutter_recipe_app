import 'package:flutter/material.dart';
import 'package:recipe/component/recipeCard.dart';
import 'package:recipe/controller/recipeRest.dart';
import '../component/drawer.dart' as drawer;
import '../model/recipeModel.dart';
import 'dart:async';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);
  String title;
  int selected = -1;
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  
  List<Recipe> recipes = [];
  int count;
  int itemRange;
  ScrollController controller;
  static const loadingTag = '##loading##';

  @override
  void initState(){
    super.initState();
    itemRange = 5;
    count = 0;
    controller = new ScrollController()..addListener(_scrollListener);
        refreshList();
      }
      //for load and refresh  
      Future refreshList() async{    
        List<Recipe> temp = await RecipeRest().getAllRecipes(range: itemRange);
        setState(() {      
          recipes = temp;
        });
        return Null;
      }
      //for lazy load more
      Future<void> lazyLoad() async{
        debugPrint("Before load:"+recipes.length.toString());
        List<Recipe> temp = await RecipeRest().getNextSetRecips(index:recipes.length);
        setState(() {      
          recipes.addAll(temp);
        });
        debugPrint("After load:"+recipes.length.toString());
      }
      
      void toggleDoneHandler(index){
        setState(() {
          widget.selected = index;
        });
      }
    
      @override
      Widget build(BuildContext context) {
    
        final topBar = AppBar(
          elevation: 0.1,
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          title: Center(child: Text(widget.title)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
              },
            )
          ],
        );
    
        final botBar = Container(
          height: 55.0,
          child: BottomAppBar(
            color: Color.fromRGBO(58, 66, 86, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.blur_on, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.hotel, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.account_box, color: Colors.white),
                  onPressed: () {},
                )
              ],
            ),
          ),
        );
      
        var listBuilder = ListView.builder(                    
              controller: controller,
              itemCount: recipes.length,          
              itemBuilder: (context, index){       
                  return RecipeCard(recipe: recipes[index]);                  
              });

        var refreshIndicator = RefreshIndicator(
            child: listBuilder, 
            onRefresh: refreshList,
          );
        return Scaffold(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.9),
          appBar: topBar,
          //bottomNavigationBar: botBar,
          //drawer: drawer.SideBar(),
          body:refreshIndicator
        );
      }
    
      void _scrollListener() {
        //debugPrint(controller.position.extentAfter.toString());
        if (controller.position.extentAfter == 0) {          
          //lazyLoad();
        }
    }
}