

import 'package:camera/camera.dart';
import 'package:ejemplo/controller/scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});
  

  @override
  Widget build(BuildContext context) {
    late FocusNode searchFocusNode;
    late FocusNode micFocusNode;
    late FocusNode aspectRatioFocusNode;
    final scanController = ScanController();
    Color backgroundColor = Theme.of(context).bottomAppBarColor;
  // ignore: prefer_function_declarations_over_variables
    void toggleTheme() {
      ThemeMode currentTheme = Get.theme!.brightness == Brightness.light
          ? ThemeMode.dark
          : ThemeMode.light;
      Get.changeThemeMode(currentTheme);
    
    }
    searchFocusNode = FocusNode();
    micFocusNode = FocusNode();
    aspectRatioFocusNode = FocusNode();
    print('estoy en camara');
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(118, 5, 5, 5),
        elevation: 0,
        leading: Image.asset('assets/Logo.png'),
        title: const Center(
          child: Text(
            "DAM",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: GetBuilder<ScanController>(
        init: scanController,
        builder: (controller){
          return controller.isCameraInicialized.value 
          ? Stack(
            children: [
              CameraPreview(controller.cameraController),
              Positioned(
                top: (controller.y) * 700,
                right: (controller.x) * 500,
                child: Container(
                  width: controller.w * 100 * context.width / 100,
                  height: controller.h * 100 * context.height / 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.deepPurple, width: 4.0 ),
                
                  ),
                 child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(controller.label),
                    )
                    ,
                  ],
                  ), 
                ),
              )
            ],
          )
          
          : const Center(child: Text("Loading Preview...")) ;
        }
      ),
      bottomNavigationBar: BottomAppBar(
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Search Button
            Focus(
              focusNode: searchFocusNode,
              child: GestureDetector(
                onTap: () {
                  // Add onPressed logic here
                  print("Search button pressed");
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: searchFocusNode.hasFocus ? Colors.grey : Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                                          ),
                  child: Semantics(
                    label: 'Search button',
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                      tooltip: 'Buscar',
                                    ),
                                  ),
                                ),
                              ),
                       ),
            // Mic Button
            Focus(
              focusNode: micFocusNode,
              child: GestureDetector(
                onTap: () {
                  // Add onPressed logic here
                  print("Mic button pressed");
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: micFocusNode.hasFocus ? Colors.grey : Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Semantics(
                    label: 'Voice command button',
                    child: IconButton(
                      icon: const Icon(Icons.mic, color: Colors.white),
                      onPressed: () {},
                      tooltip: 'Comando de voz',
                    ),
                  ),
                ),
              ),
            ),
            // Aspect Ratio Button
            Focus(
              focusNode: aspectRatioFocusNode,
              child: GestureDetector(
                onTap: () {
                  // Add onPressed logic here
                  print("Aspect Ratio button pressed");
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: aspectRatioFocusNode.hasFocus ? Colors.grey : Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Semantics(
                    label: 'Open library',
                    child: IconButton(
                      icon: const Icon(Icons.library_books_outlined,
                          color: Colors.white),
                      onPressed: () {},
                      tooltip: 'Texto',
                      ),
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}