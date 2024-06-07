


import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ScanController extends GetxController {
  String labelf = '';


  String get detectedLabel => labelf;
  final logger = Logger();
  @override
  void onInit(){
    super.onInit();
    initCamera();
    initTFLite();
  }
  @override
  void dispose() {

    super.dispose();
    cameraController.dispose();

  }
  
  late CameraController cameraController;
  late List<CameraDescription> cameras;

  late CameraImage cameraImage;
  bool _isDetecting = false;
  var isCameraInicialized = false.obs;
  var cameraCount = 0;

  double x = 0.0, y = 0.0, w = 0.0, h = 0.0;


  initCamera() async {
    if (await Permission.camera.request().isGranted)
    {
      cameras = await availableCameras();

      cameraController = 
          CameraController(cameras[0], ResolutionPreset.max, imageFormatGroup: ImageFormatGroup.unknown);
      await cameraController.initialize().then((value){
          print('estoy antes del if');
          cameraController.startImageStream((image){
            cameraCount++;
            if(cameraCount > 10){
              cameraCount = 0;
              print('estoy en el id detector');
              objectDetector(image);
              
            }
            update();
          } );
          
        
      });
      isCameraInicialized(true);
      update();

    } else {
      
      logger.d("Permission denied");
    }
  }

  initTFLite() async{
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,

    );
  }

  objectDetector(CameraImage image) async{
    logger.d("Running object detector...");
    _isDetecting = true;
    update();

    var detector = await Tflite.runModelOnFrame(
    
    bytesList: image.planes.map((e){
    return e.bytes;
      }).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 1,
      rotation: 90,
      threshold: 0.1,
      );
      print('dentro del detector antes del if');
      //print('Resultado del detector: $detector');
      if (detector != null && detector.isNotEmpty) {
        var ourDetectedObject = detector.first;
        print('dentro del detector cuando sea diferente de null');
        
       print('Resultado del detector: $detector');
       String label = detector[0]['label'];
        print('El valor de label es: $label');
        labelf = label;
        
        if(ourDetectedObject['confidenceInClass']*100>45){
         
         
          h = ourDetectedObject['react']['h'];
          w = ourDetectedObject['react']['w'];
          x = ourDetectedObject['react']['x'];
          y = ourDetectedObject['react']['y'];
        }
        _isDetecting = false;
        update();
      } 
    

  }
  
}
