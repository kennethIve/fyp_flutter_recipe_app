
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recipe/com_var.dart';
import 'package:recipe/component/drawer.dart';
import 'package:recipe/model/recipeModel.dart';



class SearchPage extends StatefulWidget {
  final Recipe recipe;

  final String title;
  const SearchPage({Key key, this.title, this.recipe}) : super(key: key);
  

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  int sortBy = 0;
  List sortByOptionLeading = [Icon(Icons.sort_by_alpha),Icon(Icons.timer),Icon(Icons.score)];
  List sortByOptions = ["Recipe Title","Cooking Time","Rating"];
  List option = ["Fast","Normal"];
  static List keywordList = [];
  TextStyle header = TextStyle(fontSize:18.0,fontWeight:FontWeight.w800);

  bool expanded = false;

  Dio req = new Dio();

  Widget _trailIcon = Icon(Icons.keyboard_arrow_right);

  var _cookTime = 60.0;

  var searhKey;

  bool loading = true;

  final textFieldController = TextEditingController();//final myController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: topBar(type: "custom",title: "Search"),
      drawer: SideBar(),
      backgroundColor: Colors.white,//Color.fromRGBO(58, 66, 86, 1.0),
      bottomNavigationBar: BottomAppBar(
        child: FlatButton(
          onPressed: () { },
          child: Icon(Icons.search),
          )
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child:SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal:screen.width*.05),           
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
              Padding(padding: EdgeInsets.all(20)),
              searchBar(),
              Padding(padding: EdgeInsets.all(10)),
              keywordsBar(),
              Padding(padding: EdgeInsets.all(10)),
              durationBar(),
              Padding(padding: EdgeInsets.all(10)),
              expansionOptForSort(),
              Padding(padding: EdgeInsets.all(10)),
              Wrap(
                direction: Axis.vertical,
                children: <Widget>[
                ],
              ),
            ],                
          ),
        ),
      )
    );
  }
  
  Widget expansionOptForSort(){    
    return Card(
      elevation: 8,
      child: ExpansionTile(
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[
          Text("Sort By",style:header),
          Text(sortByOptions[sortBy],style:TextStyle(color:Colors.grey,fontSize:18.0,fontWeight:FontWeight.w400))
        ]),
        leading:  Icon(Icons.sort),
        children: sortByBtns(),
        trailing: _trailIcon,
        onExpansionChanged: (isExpanded){
            setState(() {
              _trailIcon = Icon((isExpanded)?Icons.keyboard_arrow_down:Icons.keyboard_arrow_right);
              this.context;
            });
            
        },
      ),
    );
  }
  Widget searchBar(){
    bool barEmpty = true;
    return Card(
      semanticContainer: false,
      elevation: 8.0,
      child: Row(
        children: <Widget>[
          Expanded(flex: 1, child: Icon(Icons.search),),
          Expanded(
            flex: 8, 
            child: TextField(
              controller: textFieldController,
              style:TextStyle(color: Colors.grey,fontSize: 18.0),
              decoration: new InputDecoration(border:InputBorder.none,contentPadding: EdgeInsets.fromLTRB(5, 10, 0, 5)),
              )
            ),
          Expanded(flex: 2, 
            child: FlatButton(child: Icon(Icons.add_circle),
            onPressed: (){
              setState(() {
                if(textFieldController.text.length >0)
                  if(!keywordList.contains(textFieldController.text))
                    keywordList.add(textFieldController.text);
                  else
                    Fluttertoast.showToast(msg: "'"+textFieldController.text+"' already added",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                    );
              });
              textFieldController.clear();
            },))
        ],
      ),
    );
  }

  Widget durationBar() {
    return Card(
      elevation: 8,
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[
            Text("Cook Time",style:header),
            Text('$_cookTime Mins',style:TextStyle(color:Colors.grey,fontSize:18.0,fontWeight:FontWeight.w400)),
          ]),
          leading: Icon(Icons.timer),
        ),
        Slider(
          min: 30,max: 300,value: _cookTime ,divisions: 27,label: '$_cookTime Mins',
          onChanged: (value){
            setState(() {
              _cookTime = value;
            });
          }
        ),
       ],
      ),
    );
  }

  Widget keywordChip (String keyword,Color color){
    return new Chip(
      labelPadding: EdgeInsets.all(5.0),
      avatar: CircleAvatar(backgroundColor: Colors.blueAccent,child: Text(keyword.substring(0,1)),), 
      label: Text(keyword),
      backgroundColor: color,
      elevation: 5.0, 
      onDeleted: () { 
        setState(() {
          keywordList.remove(keyword);
        });
      },
    );
  }

  Widget keywordsBar() {
    return Card(
      elevation: 8,
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[
            Text("Keywords Chips",style:header),
          ]),
          leading: Icon(Icons.text_fields),
        ),
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          direction: Axis.horizontal,
          runSpacing: 5,
          children: List.generate(keywordList.length, (index){
            return keywordChip(keywordList[index], Colors.white);
          }),
        ),
       ],
      ),
    );
  }

  List<Widget> sortByBtns(){
    List<Widget> btnList=[];
    sortByOptions.asMap().forEach((i, v)
    {
      btnList.add(
        new InkWell(
          child: new ListTile(leading: sortByOptionLeading[i],title: Text(v),trailing: (sortBy==i)?Icon(Icons.check,color: Colors.green,):null,),
          onTap: (){sortBy = i;setState(() {});
          },
      ));
    });
    return btnList;
  }
}
