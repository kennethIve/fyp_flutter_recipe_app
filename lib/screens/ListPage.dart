import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loadmore/loadmore.dart';
import 'package:recipe/component/recipeCard.dart';
import 'package:recipe/controller/recipeRest.dart';
import '../component/drawer.dart' as drawer;
import '../model/recipeModel.dart';
import 'dart:async';
import 'package:recipe/com_var.dart';

class ListPage extends StatefulWidget {
  ListPage({
    Key key,
    this.title
  }): super(key: key);

  String title;
  int selected = -1;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State < ListPage > {

  List < Recipe > recipes;
  int count;
  int itemRange;
  ScrollController controller;
  String loadingTag = '##loading##';
  bool noMore = false;
  bool emptyload = true;

  static bool _visible = false;

  //var _orderOpts = ["none","alpha","time","star"];
  var filterStatus = [false,false,false];
  var orderBy = ["title"];
  var order = ["asc"];

  static int order_index = 0;

  var _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    itemRange = 5;
    count = 0;
    controller = new ScrollController()..addListener(_scrollListener);
    _isFirstLoad = true;
    refreshList();
  }

  //for load and refresh  
  Future<void> refreshList() async {    
    recipes = new List() ;    
    emptyload = true;
    noMore = false;    
    setState(() {});    
    await RecipeRest().getAllRecipes(range: itemRange,orderBy: orderBy,order: order).then((list){
        recipes = list;    
      setState(() {
        emptyload = false;
      });
      emptyload = false;
      _isFirstLoad = false;
    });
    
  }
  //for lazy load more
  Future <bool> lazyLoad() async {
    var before = recipes.length;
    await Future.delayed(Duration(milliseconds: 1500));
    try{
      await RecipeRest().getAllRecipes(start: before,orderBy: orderBy,order: order).then((list){
        recipes.addAll(list);
        setState(() {});
        var after = recipes.length;
        noMore = (before==after);
        return true;
      }).whenComplete((){
        return true;
      });
    }catch(e){
      debugPrint(e);
      return false;
    }
      return true;
  }

  void toggleDoneHandler(index) {
    setState(() {
      widget.selected = index;
    });
  }
  void filterClick(String fliter){
    _isFirstLoad = true;

    var index = orderBy.indexOf(fliter);
    try {
      filterStatus[index] = !filterStatus[index];
      order[index] = order[index] != "desc" ? "desc":"asc"; 
    } catch (e) {
      filterStatus = [false,false,false];
      orderBy = ["title"];
      order = ["asc"];
    }    
    refreshList();
  }
  Widget filterBtn (BuildContext context){
      return SpeedDial(
          // both default to 16
          marginRight: 18,
          marginBottom: 20,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          closeManually: false,
          curve: Curves.easeInExpo,
          //overlayColor: Colors.black,
          visible: !emptyload,
          overlayOpacity: 0.5,
          onOpen:  () {},
          onClose: () {},
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.timer),
              backgroundColor:Colors.blueGrey,
              //label: 'Time',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                filterClick("cook_time");
              }
            ),
            SpeedDialChild(
              child: Icon(Icons.star),
              backgroundColor:Colors.green,
              //label: 'Star',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                filterClick("rating");
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.replay),
              backgroundColor:Colors.blueGrey,
              label: 'Filter by',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                filterClick("reset");
              },
            ),
          ],
        );
      }


  @override
  Widget build(BuildContext context) {
    
    ListView listBuilder = new ListView.builder(      
      padding: EdgeInsets.only(top: 15),      
      itemCount: recipes.length,
      itemBuilder: (context, index) {                        
        return RecipeCard(recipe: recipes[index]);
      });
    
    //load more tag at listview last page  
    return Scaffold(
      backgroundColor: commonBackground,      
      appBar: topBar(type: "listPage", search: () {return showSearch(context: context, delegate: DataSearch());}),
      //bottomNavigationBar: botBar,
      drawer: drawer.SideBar(),
      floatingActionButton: filterBtn(context),// form com_var
      bottomSheet: null,
      body: Stack(
          children: [
            RefreshIndicator(        
              onRefresh: refreshList,
              color: Colors.amber,
              child: new LoadMore(
                child: listBuilder, 
                onLoadMore: lazyLoad,
                whenEmptyLoad: _isFirstLoad,
                isFinish: noMore,
                textBuilder: (status){
                  String text;
                  switch (status) {
                    case LoadMoreStatus.fail:
                      text = "Process fail, click to retry!";
                      break;
                    case LoadMoreStatus.idle:
                      text = "Waiting for more recipe~";
                      break;
                    case LoadMoreStatus.loading:
                      text = "Loading，please wait...";
                      break;
                    case LoadMoreStatus.nomore:
                      text = "No More Recipe Found!";
                      break;
                    default:
                      text = "";
                  }
                  return text;
                },
              ),
              ),
           ]
        ),
    );
  }

  void _scrollListener() {
    debugPrint(controller.position.extentAfter.toString());    
    if (controller.position.extentAfter == 0) {
      //lazyLoad();
    }
  }
}
//search button of the list page
class DataSearch extends SearchDelegate {

  static List < String > recipeNames = [];
  static List<Recipe> suggestionList = [];
  static List<Recipe> theListList = [];
  static String current;

  DataSearch(): super(
    searchFieldLabel: "Search here",
  );
  @override
  ThemeData appBarTheme(BuildContext context) {
    return defaultTheme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: defaultTheme.primaryIconTheme.copyWith(color: Colors.grey),      
      textTheme: defaultTheme.textTheme.copyWith(headline6:defaultTheme.textTheme.headline6.copyWith(color:Colors.black,),),      
    );
  }
  @override
  List < Widget > buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.backspace), onPressed: () {
      query = "";
    }, )];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation
      ), 
      onPressed: () {
        close(context, null);
      }, 
    );
  }


  @override
  Widget buildResults(BuildContext context) {//show result base on selection
    return FutureBuilder(
      future:getRecipeByKeyword(result: true),  
      builder: (BuildContext context,AsyncSnapshot snapshot){
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {            
            return Center(child:Text("Network Connection Fail"));
          } else {            
            return snapshot.data;
          }
        } else {          
          return Center(child: CircularProgressIndicator(),);
        }
      }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //showSuggestions(context);    
    if(query.isEmpty)
      return 
      Column(        
        children:[
          Center(
            child: Text("Waiting for your input",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20,color: Colors.blueGrey),)
          )
        ]
      );      
    return FutureBuilder(
      future:getRecipeByKeyword(),  
      builder: (BuildContext context,AsyncSnapshot snapshot){
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {            
            return Center(child:Text("Network Connection Fail"));
          } else {            
            return snapshot.data;
          }
        } else {          
          return LinearProgressIndicator();          
        }
      }
    );
  }

  Future<ListView> getRecipeByKeyword({bool result=false}) async{
    List<Recipe> suggestionList = await RecipeRest().getRecipeByKeyword(query,take: 20);
    debugPrint("getrecipebykey build result"+suggestionList.length.toString());
    return ListView.builder(      
      padding: EdgeInsets.only(top: 10),
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {        
        var title = suggestionList[index].title;
        if(result)
          return RecipeCard(recipe: suggestionList[index]);
        return ListTile(leading: Icon(Icons.restaurant_menu),title: Text(title),onTap: (){query = title; showResults(context);},);
      });
  }

}