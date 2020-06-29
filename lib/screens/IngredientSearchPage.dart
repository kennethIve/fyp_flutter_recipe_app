import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recipe/com_var.dart';
import 'package:recipe/component/drawer.dart';
import 'package:recipe/model/recipeModel.dart';
import 'package:recipe/screens/SearchPageList.dart';

import 'ObjectDetectPage.dart';

class IngredientSearchPage extends StatefulWidget {
  IngredientSearchPage({Key key}) : super(key: key);

  @override
  _IngredientSearchPageState createState() => _IngredientSearchPageState();
}

class _IngredientSearchPageState extends State<IngredientSearchPage> {

  static List ingredients = [];
  static var _scrollController = ScrollController();
  
  final List<String> _gridImg = [
    "assets/ingreLogo/Fruits.png",
    "assets/ingreLogo/Meats.png",
    "assets/ingreLogo/SeaFood.png",
    "assets/ingreLogo/Vegetables.png",
  ];
  final List ingredientList = [
    ["apple","banana"],//fruit
    ["beef","chicken"],//meat
    ["shrimp","tuna"],//seafood
    ["eggplant","carrot","tomato","cabbage"],//vegetables
  ];

  var textFieldController = TextEditingController();
  void addIngredients(){
    setState(() {
      if(textFieldController.text.length >0)
        if(!ingredients.contains(textFieldController.text)){
          ingredients.add(textFieldController.text);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: topBar(type: "custom",title: "Ingredient Search"),
          drawer: SideBar(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            child: Icon(Icons.camera_enhance),
            onPressed: () {
              availableCameras().then((cameras) async {
                List<String> result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ObjectDetectPage(cameras: cameras,)));
                if(result != null && result.length > 0){
                  //ingredients.addAll(result);
                  for(String ingre in result){
                    if(ingredients.contains(ingre))
                      continue;
                    ingredients.add(ingre);
                  }
                }
                setState(() {});
              });                         
            },
          ),
          bottomNavigationBar: BottomAppBar(
            child: IconButton(
              color: defaultTheme.primaryColor,
              icon: Icon(Icons.search), 
              onPressed: (){
                print(_queryBuilder());
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPageList(query: _queryBuilder(),ingredientSearch: true,)));
              }
            ),
          ),
          backgroundColor: commonBackground,
          body: Container(
            alignment:Alignment.topCenter,
            padding: EdgeInsets.only(top:20,left: 20,right: 20,),
            child:SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  searchBar(),
                  ingredientBar(),
                  Card(
                    child:Text("Categories"),
                  ),
                  //Expanded(child: 
                    GridView.count(
                      shrinkWrap: true,
                      controller: _scrollController,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: List.generate(_gridImg.length, (index) => InkWell(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage(_gridImg[index]), fit: BoxFit.cover),          
                          ),
                          child: //Card(child: 
                            Text(_gridImg[index].split("/").last.split(".").first),
                          //),
                        ),
                        onTap: (){ 
                          debugPrint(index.toString());
                          showfilterModal(context,index);
                        },
                      )
                      ).toList(),
                    ),
                  //),
                  //Text("hello"),
                ],
              ),
            )
          ),
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
                addIngredients();
              },
              )
            ),
          Expanded(flex: 2, 
            child: IconButton(
              icon: Icon(Icons.add_circle,color: Colors.black,),
              onPressed: addIngredients,
            )
          ),
        ],
      ),
    );
  }
  Widget ingredientBar() {
    return Card(
      elevation: 8,
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[
            Text("Ingredients Chips",style:header),
          ]),
          leading: Icon(Icons.text_fields),
        ),
        Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          runSpacing: 5,
          spacing: 5,
          children: List.generate(ingredients.length, (index){
            return keywordChip(ingredients[index], Colors.white);
          }),
        ),
        Padding(padding: EdgeInsets.all(5),),
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
          ingredients.remove(keyword);
        });
      },
    );
  }

  void showfilterModal(BuildContext context,int index) async{
  TextStyle mystyle = TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0);
  ShapeBorder shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0));
  List tempList = ingredients;
  List ingre = ingredientList[index];
  //ingre.removeWhere((element) => tempList.contains(element));
  Dialog dialog = Dialog(
    //backgroundColor: Colors.yellow[50],
    shape: shape,
    insetPadding: EdgeInsets.fromLTRB(5, 5, 5, 0),        
    child: Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * .5,
      width: MediaQuery.of(context).size.width * .6,
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: ingre.length,
          itemBuilder: (context,i){            
            return ListTile(
              leading: Icon(Icons.restaurant_menu),
              title: Text(ingre[i],style: mystyle,),
              trailing: Icon(Icons.add_circle_outline),
              onTap: (){
                if(!ingredients.contains(ingre[i])){
                  ingredients.add(ingre[i]);
                }else
                  Fluttertoast.showToast(msg: ingre[i]+" is added");
                setState(() {});
              },
            );
          }
          ),
        )        
      )
  );
  showDialog(context: context,builder: (BuildContext context) => dialog);
  }

  Map<String,dynamic> _queryBuilder(){
    return {
      "from":0,
      "to":600,
      "orderBy":["rating desc"],
      //"keywords":keywordList.length>0?keywordList:[""]
      "ingredients":ingredients.length > 0 ? ingredients:[]
    };
  }
}
