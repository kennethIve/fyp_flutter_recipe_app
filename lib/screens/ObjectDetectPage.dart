import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String _model = "mobilenet";
  int btn = 1;
  bool isDetecting = false;
  List<dynamic> ingredients=[];
  List<String> results = [];
  CameraController controller;
  bool scan_flag = false;

  static List<dynamic> _recognitions;
  static int _imageHeight = 0;
  static int _imageWidth = 0;

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  void initState() { 
    super.initState();
    _model = "";
    scan_flag = false;
    initModel();
    //load a camera to camera chotroller
    controller = CameraController(widget.cameras[0], ResolutionPreset.high,enableAudio: false);        
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
            numResultsPerClass: 1,
            numBoxesPerBlock: 3,
            threshold: 0.5,
            //asynch: false,
          ).then((recognitons){
            if(recognitons.length>0){
              ingredients = recognitons;
              //debugPrint(recognitons.toList()[0].toString());
              String detected = recognitons[0]["detectedClass"].toString();
              if(!results.contains(detected)){          
                results.add(detected);
              }              
            }            
            //setState(() {});            
            setRecognitions(recognitons, img.height, img.width);
            setState(() {});
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
    double height = (screen.height/5)*3;
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
                    height: height,
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
                            elevation: 1,                       
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
                        )),
                        BBox(
                          ingredients == null ? [] : ingredients,
                          math.max(_imageHeight, _imageWidth),
                          math.min(_imageHeight, _imageWidth),
                          height,
                          screen.width,
                        ),
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