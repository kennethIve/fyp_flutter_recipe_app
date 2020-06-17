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
  var order_option = ["none","alpha","time","star"];
  static int order_index = 0;//alphabetic 1

  @override
  void initState() {
    super.initState();
    itemRange = 5;
    count = 0;
    //controller = new ScrollController()..addListener(_scrollListener);    
    refreshList();
  }

  //for load and refresh  
  Future<void> refreshList() async {    
    recipes = new List() ;    
    emptyload = true;
    noMore = false;
    setState(() {});    
    List < Recipe > temp = await RecipeRest().getAllRecipes(range: itemRange);
    recipes = temp;    
    setState(() {
      emptyload = false;
    });
    emptyload = false;
  }
  //for lazy load more
  Future <bool> lazyLoad() async {
    var before = recipes.length;
    await Future.delayed(Duration(milliseconds: 1500));
    List <Recipe> temp = await RecipeRest().getNextSetRecips(index: recipes.length);
    recipes.addAll(temp);
    setState(() {});
    var after = recipes.length;
    noMore = (before==after);
    return true;
  }

  void toggleDoneHandler(index) {
    setState(() {
      widget.selected = index;
    });
  }

  // Widget filterBtn (BuildContext context){
  //   return FloatingActionButton(
  //     child: Icon(Icons.format_list_bulleted),
  //     backgroundColor: defaultTheme.primaryColor,
  //     onPressed: (){ showfilterModal(context);},
  //   );
  // }
  Widget filterBtn (BuildContext context){
      return SpeedDial(
          // both default to 16
          marginRight: 18,
          marginBottom: 20,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          closeManually: false,
          curve: Curves.bounceIn,
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
              onTap: () {}
            ),
            SpeedDialChild(
              child: Icon(Icons.star),
              backgroundColor:Colors.blueGrey,
              //label: 'Star',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {},
            ),
            SpeedDialChild(
              child: Icon(Icons.text_rotate_vertical),
              backgroundColor:Colors.blueGrey,
              label: 'Filter by',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {},
            ),
          ],
        );
      }


  @override
  Widget build(BuildContext context) {
    
    ListView listBuilder = new ListView.builder(      
      padding: EdgeInsets.only(top: 10),      
      itemCount: recipes.length,
      itemBuilder: (context, index) {                        
        return RecipeCard(recipe: recipes[index]);
      });
    
    //load more tag at listview last page  
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.9),
      appBar: topBar(type: "listPage", search: () {return showSearch(context: context, delegate: DataSearch());}),
      //bottomNavigationBar: botBar,
      drawer: drawer.SideBar(),
      floatingActionButton: filterBtn(context),// form com_var
      bottomSheet: null,
      body: RefreshIndicator(
        onRefresh: refreshList,
        color: Colors.amber,
        child: new LoadMore(
          child: listBuilder, 
          onLoadMore: lazyLoad,
          whenEmptyLoad: true,
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


}