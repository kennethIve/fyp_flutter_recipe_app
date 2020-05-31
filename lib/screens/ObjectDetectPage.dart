import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
  CameraController controller;

  @override
  void initState() { 
    super.initState();
    _model = "";
    initModel();
    //load a camera to camera chotroller
    controller = CameraController(widget.cameras[0], ResolutionPreset.max,enableAudio: false);        
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      doRecognition();      
    });
  }

  //release resourcess
  @override
  void dispose(){    
    //ObjectRecognition?.close();
    controller?.dispose();
    super.dispose();
  }
  
  void initModel() async{
    debugPrint("initModel():init tflit model");
    if (_model != "success")
      _model = await ObjectRecognition.init(); 
  }
  
  void doRecognition() {
    controller.startImageStream((CameraImage img){
      setState(() {});   
      //if(_model == "success"){
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
            numBoxesPerBlock: 3,
            threshold: 0.2              
          ).then((recognitons){
            ingredients = recognitons.toList();
            setState(() {});           
            //int endTime = new DateTime.now().millisecondsSinceEpoch;
            //int duration = endTime-startTime;            
            //debugPrint("run finish, process take:$duration");
            //debugPrint(recognitons.toList()[0]["detectedClass"].toString());
            isDetecting = false;              
          });                       
        }          
      //}
    });
      //controller.stopImageStream();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }    
    return Material(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                    width: screen.width,
                    height: (screen.height/4)*3,
                    child:Stack(
                      fit: StackFit.loose,
                      overflow: Overflow.clip,
                      children:<Widget>[
                        AspectRatio(
                            aspectRatio: 4/6,
                            child: CameraPreview(controller),
                          )
                      ])
              ),
            new Container(
              width: screen.width,
              height: (screen.height/4),
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (BuildContext context, int index) {
                return ListTile(title:new Text(ingredients[index]["detectedClass"].toString()));
              },
              ),
            ),
          ])
    );
  }

}