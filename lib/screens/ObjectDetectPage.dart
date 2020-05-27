import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:recipe/controller/objectRecognition.dart';

//preview and do object regconition
class ObjectDetectPage extends StatefulWidget {

  final List<CameraDescription> cameras;

  ObjectDetectPage({Key key, this.cameras}) : super(key: key);

  @override
  _ObjectDetectPageState createState() => _ObjectDetectPageState();
}

class _ObjectDetectPageState extends State<ObjectDetectPage> {

  List<dynamic> _recognition;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";
  int btn = 1;

  CameraController controller;

  @override
  void initState() { 
    super.initState();
    var cameras;
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void initModel() async{
    btn++;
    debugPrint("$btn");
    if (_model != "success")
      _model = await ObjectRecognition.init();
    setState((){
             
    });    
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
                child: CameraPreview(controller)
              ),
              Center(child:RaisedButton(child: Text("$btn"),onPressed: () => initModel())),
            ]
          );
    
  }
}

// return Scaffold(
    //   body: _model == ""
    //       ? Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               RaisedButton(
    //                 child: const Text("Start to Recognize Ingredients"),
    //                 onPressed: () => (){initModel();},
    //               ),
    //               AspectRatio(
    //                 aspectRatio: 4 / 4,
    //                 child: CameraPreview(CameraController(widget.cameras[0],ResolutionPreset.medium)),
    //               )
    //             ],
    //           ),
    //         )
    //       : Stack(
    //           children: [                
                // Camera(
                //   widget.cameras,
                //   _model,
                //   setRecognitions,
                // ),
                // BndBox(
                //     _recognitions == null ? [] : _recognitions,
                //     math.max(_imageHeight, _imageWidth),
                //     math.min(_imageHeight, _imageWidth),
                //     screen.height,
                //     screen.width,
                //     _model),
    //           ],
    //         ),
    // );