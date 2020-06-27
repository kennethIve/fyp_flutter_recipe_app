import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recipe/component/BBox.dart';
import 'package:recipe/controller/objectRecognition.dart';
import 'package:recipe/screens/SearchPage.dart';

import 'dart:math' as math;

import 'package:tflite/tflite.dart';


//preview and do object regconition
class ObjectDetectPage extends StatefulWidget {

  final List<CameraDescription> cameras;

  ObjectDetectPage({Key key, this.cameras}) : super(key: key);

  @override
  _ObjectDetectPageState createState() => _ObjectDetectPageState();
}

class _ObjectDetectPageState extends State<ObjectDetectPage> {

  // List<dynamic> _recognition;
  // int _imageHeight = 0;
  // int _imageWidth = 0;
  String _model = "";
  int btn = 1;
  bool isDetecting = false;
  List<dynamic> ingredients=[];
  List<String> results = [];
  CameraController controller;
  bool scan_flag = false;

  @override
  void initState() { 
    super.initState();
    _model = "";
    scan_flag = false;
    initModel();
    //load a camera to camera chotroller
    controller = CameraController(widget.cameras[0], ResolutionPreset.veryHigh,enableAudio: false);        
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }else{
        doRecognition();
      }
    });
  }

  //release resourcess
  @override
  void dispose(){    
    //ObjectRecognition?.close();
    //Tflite.close();    
    controller?.dispose();
    super.dispose();
  }
  
  void initModel() async{
    debugPrint("initModel():init tflit model");
    if (_model != "success")
      _model = await ObjectRecognition.init(); 
  }
  
  void doRecognition() {
    if(!mounted)
      return;
    controller.startImageStream((CameraImage img){
      if(mounted)
        setState(() {});
      //object detection code
      if(scan_flag){
        if(!isDetecting){
          isDetecting = true;
          //int startTime = new DateTime.now().millisecondsSinceEpoch;
          Tflite.detectObjectOnFrame(
            bytesList: img.planes.map((planes)=>planes.bytes).toList(),
            model: "SSDMobileNet",
            imageHeight: img.height,imageWidth: img.width,
            imageMean: 127.5,
            imageStd: 127.5,
            numResultsPerClass: 5,
            //numBoxesPerBlock: 5,
            threshold: 0.6              
          ).then((recognitons){
            if(recognitons.length>0){
              ingredients = recognitons.toList();
              debugPrint(recognitons.toList()[0].toString());
              String detected = recognitons[0]["detectedClass"].toString();
              if(!results.contains(detected)){          
                results.add(detected);
              }
            }
            //setState(() {});           
            //int endTime = new DateTime.now().millisecondsSinceEpoch;
            //int duration = endTime-startTime;            
            //debugPrint("run finish, process take:$duration");
            isDetecting = false;              
          });                       
        }          
      }
    });
      //controller.stopImageStream();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }    
    return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.indigoAccent,
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.pop(context,results);
            },
          ),
          body: Column(
          mainAxisAlignment: MainAxisAlignment.start,          
          children: <Widget>[
            Container(
                    width: screen.width,
                    height: (screen.height/5)*3,
                    child:Stack(
                      fit: StackFit.expand,
                      overflow: Overflow.clip,
                      children:<Widget>[
                        AspectRatio(
                            aspectRatio: 4/6,
                            child: CameraPreview(controller),
                          ),
                        Positioned(
                          right: 30,
                          bottom: 30,
                          child: FloatingActionButton(                            
                            child: Icon(Icons.camera_rear),
                            backgroundColor: (scan_flag)?Colors.green:Colors.grey,
                            onPressed: (){
                              scan_flag = (scan_flag)?false:true;
                              Fluttertoast.showToast(msg: (scan_flag)?"Start Scaning Ingredients":"Scanning Stop",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: (scan_flag)?Colors.green:Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0                                  
                              );
                              setState(() {});
                            },
                        ))
                      ])
              ),
            new Container(
              width: screen.width,
              height: (screen.height/5)*2,
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (BuildContext context, int index) {
                //return ListTile(title:new Text(ingredients[index]["detectedClass"].toString()));
                return ListTile(
                  leading: Icon(Icons.restaurant_menu),
                  title:new Text(results[index]),
                  );
              },
              ),
            ),
          ])
    );
  }

}