import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:recipe/com_var.dart';
import 'package:recipe/component/drawer.dart';
import 'package:recipe/model/recipeModel.dart';



class SearchPage extends StatefulWidget {
  const SearchPage({Key key, this.title, this.recipe}) : super(key: key);

  final Recipe recipe;
  final String title;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  int sortBy = 0;
  List sortByOptionLeading = [Icon(Icons.sort_by_alpha),Icon(Icons.timer),Icon(Icons.score)];
  List sortByOptions = ["Recipe Title","Cooking Time","Rating"];
  List option = ["Fast","Normal"];

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
  List<Widget> sortByBtns(){
    List<Widget> btnList=[];
    btnList.add(Text("Sort By",style:TextStyle(fontSize:18.0,fontWeight:FontWeight.w800)));
    sortByOptions.asMap().forEach((i, v)
    {
      btnList.add(
        new InkWell(
          child: ListTile(leading: sortByOptionLeading[i],title: Text(v),trailing: (sortBy==i)?Icon(Icons.check,color: Colors.green,):null,),
          onTap: (){sortBy = i;setState(() {});
          },
      ));
    });
    return btnList;
  }
  ExpansionPanelList expansionOpt(){
    return ExpansionPanelList(
      animationDuration: Duration(seconds:1),
      children: [ExpansionPanel(headerBuilder: (context,flag){return Text("data");}, body: Text("data2"),isExpanded: false),]
    );
  }
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
          appBar: topBar(type: "custom",title: "Search"),
          drawer: SideBar(),
          backgroundColor: Colors.white,//Color.fromRGBO(58, 66, 86, 1.0),
          body: Container(
              alignment: Alignment.center,
              child:SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal:screen.width*.05),           
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 100,
                      child: SearchBar(
                        onSearch: (value){
                          debugPrint(value);
                          return;
                          },
                        onItemFound: (obj,index){
                          debugPrint(obj);
                          return;
                          },
                        onError: (e){return;},
                      ),),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:sortByBtns()                          
                      )
                    ),
                    Container(child: expansionOpt(),),
                   FlatButton(
                        color:Colors.blue[600],
                        textColor:Colors.white,
                        padding: EdgeInsets.symmetric(horizontal:40.0),                        
                        child:Text("Find Recipe Now",style:TextStyle(fontSize:18.0,fontWeight:FontWeight.bold)),
                        onPressed:(){},
                    ),
                  ],
                )
              ),
            ),
    );
  }
}
