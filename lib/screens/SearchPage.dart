
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recipe/com_var.dart';
import 'package:recipe/component/drawer.dart';
import 'package:recipe/model/recipeModel.dart';
import 'package:recipe/screens/SearchPageList.dart';



class SearchPage extends StatefulWidget {
  final Recipe recipe;

  final String title;
  const SearchPage({Key key, this.title, this.recipe}) : super(key: key);
  

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  static int sortBy = 0;
  List sortByOptionLeading = [Icon(Icons.sort_by_alpha),Icon(Icons.timer),Icon(Icons.score)];
  List sortByOptions = ["Recipe Title","Cooking Time","Rating"];
  List<String> sortList = ["title asc","cook_time asc","rating desc"];
  List option = ["Fast","Normal"];
  static List keywordList = [];
  TextStyle header = TextStyle(fontSize:18.0,fontWeight:FontWeight.w800);

  bool expanded = false;

  Dio req = new Dio();

  Widget _trailIcon = Icon(Icons.keyboard_arrow_right);

  RangeValues _cookTime = RangeValues(40.0, 210.0);

  var searhKey;

  bool loading = true;

  final textFieldController = TextEditingController();//final myController = TextEditingController();

  void addKeywords(){
    setState(() {
      if(textFieldController.text.length >0)
        if(!keywordList.contains(textFieldController.text)){
          keywordList.add(textFieldController.text);
          textFieldController.clear();
        }else
          Fluttertoast.showToast(msg: "'"+textFieldController.text+"' already added",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          );
    });
  }

  Map<String,dynamic> _queryBuilder(){
    return {
      "from":_cookTime.start.toInt(),
      "to":_cookTime.end.toInt(),
      "orderBy":[sortList[sortBy]],
      "keywords":keywordList
    };
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    //change theme setting for this context
    //Theme.of(context).copyWith(iconTheme: IconThemeData(color: Colors.red),);
    return Scaffold(
      appBar: topBar(type: "custom",title: "Search",color: defaultTheme.backgroundColor),
      drawer: SideBar(),
      backgroundColor: commonBackground,//Color.fromRGBO(58, 66, 86, 1.0),      
      floatingActionButton: FloatingActionButton(        
        child: Icon(Icons.search),
        onPressed: () {
          //make a query and pass to searh page list page
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPageList(query: _queryBuilder(),)));
        },
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
          Expanded(flex: 2, child: Icon(Icons.search,color: Colors.black,),),      
          Expanded(
            flex: 8, 
            child: TextField(
              controller: textFieldController,
              style:TextStyle(color: Colors.grey,fontSize: 18.0),
              decoration: new InputDecoration(border:InputBorder.none,contentPadding: EdgeInsets.fromLTRB(5, 10, 0, 5)),
              onSubmitted: (text){
                addKeywords();
              },
              )
            ),
          Expanded(flex: 2, 
            child: IconButton(
              icon: Icon(Icons.add_circle,color: Colors.black,),
              onPressed: addKeywords,
            )
          ),
        ],
      ),
    );
  }
  
  String _cookTimeMessage(){
    var start = _cookTime.start.round();
    var end = _cookTime.end.round();
    if(start == end){
      if(start==10)
        return "< $end";
      else if(end == 250)
        return "> $end";
      return "~ $end";
    }else
      return "$start ~ $end";
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
            Text(_cookTimeMessage()+' Mins',style:TextStyle(color:Colors.grey,fontSize:18.0,fontWeight:FontWeight.w400)),
          ]),
          leading: Icon(Icons.timer),
        ),
        RangeSlider(
          min: 10.0,max: 250.0  ,divisions: 21,
          onChanged: (RangeValues value){
            setState(() {
              _cookTime = value;
            });
          }, 
          values: _cookTime,
        ),
       ],
      ),
    );
  }

  Widget keywordChip (String keyword,Color color){
    return new Chip(
      labelPadding: EdgeInsets.all(5.0),
      avatar: CircleAvatar(backgroundColor: Colors.orange,child: Text(keyword.substring(0,1),style: TextStyle(color: Colors.white),),), 
      label: Text(keyword),
      backgroundColor: color,
      elevation: 4.0, 
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
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          runSpacing: 5,
          spacing: 5,
          children: List.generate(keywordList.length, (index){
            return keywordChip(keywordList[index], Colors.white);
          }),
        ),
        Padding(padding: EdgeInsets.all(5),)
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
