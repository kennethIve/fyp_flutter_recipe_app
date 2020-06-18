import 'package:dio/dio.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:recipe/com_var.dart';
import 'package:recipe/component/drawer.dart';
import 'package:recipe/model/recipeModel.dart';

class SearchPage extends StatefulWidget {

  const SearchPage({Key key, this.title, this.recipe}) : super(key: key);
  final String title;
  final Recipe recipe;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List option = ["Fast","Normal","Long","Normal","Long","Normal","Long","Normal","Long","Normal","Long","Normal","Long"];

  List<Widget> optionbuilder(List options){
    List<Widget> wlist = new List<Widget>();
    options.forEach((element) { 
      wlist.add(new FlatButton(onPressed: (){},child: Text(element),));
    });
    return wlist;
  }

  Widget duration(){
    return Card(    
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Cooking Duration",style: TextStyle(fontSize:24,fontWeight:FontWeight.w800),),
        Wrap(
          spacing: 10,      
          children: optionbuilder(option),
        )
      ]),
      );
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
          appBar: topBar(type: "custom",title: "Search"),
          drawer: SideBar(),
          backgroundColor: Colors.white,//Color.fromRGBO(58, 66, 86, 1.0),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,                
                children: [
                  Container(
                    height: 100,
                    width: screen.width*.9,
                    child: SearchBar(onSearch: null, onItemFound: null),
                  ),
                  Expanded(
                    child: Column(
                      children:[
                        duration(),
                        duration(),
                        duration(),
                      ]
                    )
                    )
                ],
              )
            ),
          )
        )
    );
  }
}