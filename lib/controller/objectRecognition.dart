library recognition;

import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
//camera module


class ObjectRecognition{
  //load models
  static Future<String> init() async{
    String res = await Tflite.loadModel(
    model: "assets/detect.tflite",
    labels: "assets/labelmap.txt",
    numThreads: 1
    );
    return res;
  }

  //close loaded models
  static Future<String> close() async{
    String res = await Tflite.close();
    return res;
  }

  static Future doRecogntion(CameraImage img) async{    
    var recognitions = await Tflite.runModelOnFrame(
      bytesList: img.planes.map((plane) {return plane.bytes;}).toList(),// required
      imageHeight: img.height,
      imageWidth: img.width,
      imageMean: 127.5,   // defaults to 127.5
      imageStd: 127.5,    // defaults to 127.5
      rotation: 90,       // defaults to 90, Android only
      numResults: 5,      // defaults to 5
      threshold: 0.1,     // defaults to 0.1
      asynch: true        // defaults to true
    );
    return recognitions;
  }

}