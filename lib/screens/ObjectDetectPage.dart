import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:recipe/component/BBox.dart';
import 'package:recipe/controller/objectRecognition.dart';

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

  CameraController controller;

  @override
  void initState() { 
    super.initState();
    _model = "";
    ObjectRecognition.init();
    //load a camera to camera chotroller
    controller = CameraController(widget.cameras[0], ResolutionPreset.high,enableAudio: false);        
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});      
    });
  }

  //release resourcess
  @override
  void dispose(){    
    ObjectRecognition?.close();
    controller?.dispose();    
    super.dispose();
  }
  
  void initModel() async{
    debugPrint("initModel():init tflit model");
    if (_model != "success")
      _model = await ObjectRecognition.init(); 
  }
  
  void doRecognition() async{
    await controller.startImageStream((CameraImage img){        
        if(_model == "success"){
          if(!isDetecting){
            isDetecting = true;
            int startTime = new DateTime.now().millisecondsSinceEpoch;
            debugPrint("run model");
            Tflite.detectObjectOnFrame(
              bytesList: img.planes.map((planes)=>planes.bytes).toList(),
              model: "SSDMobileNet",
              imageHeight: img.height,imageWidth: img.width,
              imageMean: 127.5,
              imageStd: 127.5,
              numResultsPerClass: 3,
              numBoxesPerBlock: 3,
              threshold: 0.2              
            ).then((recognitons){
              int endTime = new DateTime.now().millisecondsSinceEpoch;
              int duration = endTime-startTime;            
              debugPrint("run finish, process take:$duration");
              debugPrint(recognitons.toList()[0]["detectedClass"].toString());
              isDetecting = false;              
            }).whenComplete((){
              controller.stopImageStream();
            });                        
          }          
        }
      });
      controller.stopImageStream();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    debugPrint("model value:"+_model+"  cameras:"+widget.cameras.toString());
    return Stack(
            fit: StackFit.loose,
            overflow: Overflow.clip,
            children:<Widget>[
              Container(
                width: screen.width,
                height: 500,
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(controller),
                )
              ),
              Center(child:RaisedButton(child: Text("do recognition"),onPressed: doRecognition,))
              //BBox(previewH, previewW, screenH, screenW, model, results),
            ]
          );
    
  }
}

