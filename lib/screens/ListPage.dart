
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  List < Recipe > recipes = [];
  int count;
  int itemRange;
  ScrollController controller;
  String loadingTag = '##loading##';
  bool noMore = false;

  @override
  void initState() {
    super.initState();
    itemRange = 5;
    count = 0;
    controller = new ScrollController()..addListener(_scrollListener);
    refreshList();
  }
  //for load and refresh  
  Future<void> refreshList() async {
    List < Recipe > temp = await RecipeRest().getAllRecipes(range: itemRange);
    noMore = false;
    setState(() {
      recipes = temp;
    });    
  }
  //for lazy load more
  Future <bool> lazyLoad() async {
    var before = recipes.length;
    await Future.delayed(Duration(milliseconds: 1500));
    List <Recipe> temp = await RecipeRest().getNextSetRecips(index: recipes.length);
    recipes.addAll(temp);
    setState(() {
      
    });
    var after = recipes.length;
    noMore = (before==after);
    return true;
  }

  void toggleDoneHandler(index) {
    setState(() {
      widget.selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    //RaisedButton loadMore = RaisedButton(onPressed: (){lazyLoad();},child: Text("$loadingTag"),);

    ListView listBuilder = new ListView.builder(
      //controller: controller,
      padding: EdgeInsets.only(top: 10),
      //physics: const AlwaysScrollableScrollPhysics(),
      itemCount: recipes.length,
      itemBuilder: (context, index) {                
        //return (index==recipes.length)?Container(child:loadMore):RecipeCard(recipe: recipes[index]);
        return RecipeCard(recipe: recipes[index]);
      });

    RefreshIndicator refreshIndicator = new RefreshIndicator(
      child: listBuilder,
      onRefresh: refreshList,
    );
    //load more tag at listview last page  
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.9),
      appBar: topBar(type: "listPage", search: () {
        return showSearch(context: context, delegate: DataSearch());
      }),
      //bottomNavigationBar: botBar,
      drawer: drawer.SideBar(),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: LoadMore(
          child: listBuilder, 
          onLoadMore: lazyLoad,
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
          },),
        )
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

  static List < String > recipeNames = ["chicken"];
  static List<Recipe> suggestionList = [];
  static String current;

  DataSearch(): super(searchFieldLabel: "Search here",);

  @override
  List < Widget > buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.backspace), onPressed: () {
      super.query = "";
    }, )];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation), onPressed: () {
      close(context, null);
    }, );
  }


  @override
  Widget buildResults(BuildContext context) {    
    return buildSuggestions(context);    
  }

  Future<ListView> getRecipeByKeyword() async{
    List list = await RecipeRest().getRecipeByKeyword(query);  
    return ListView.builder(      
      padding: EdgeInsets.only(top: 10),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return RecipeCard(recipe: list[index]);
      });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    showSuggestions(context);
    debugPrint("show suggestion");
    if(query.isEmpty)
      return Column(children:[Center(child: Text("You can find your recipe by name",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.blueGrey),))]);
    return FutureBuilder(      
      future:getRecipeByKeyword(),
      builder: (BuildContext context,AsyncSnapshot snapshot){
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // 请求失败，显示错误
            return Center(child:Text("Network Connection Fail"));
          } else {
            // 请求成功，显示数据
            return snapshot.data;
          }
        } else {
          // 请求未结束，显示loading
          return LinearProgressIndicator();          
        }
      }
    );
  }


}