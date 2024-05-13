

import 'package:camera/camera.dart';
import 'package:ejemplo/controller/scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    final scanController = ScanController();
    

    Color backgroundColor = Theme.of(context).bottomAppBarColor;
  // ignore: prefer_function_declarations_over_variables
    void toggleTheme() {
      ThemeMode currentTheme = Get.theme!.brightness == Brightness.light
          ? ThemeMode.dark
          : ThemeMode.light;
      Get.changeThemeMode(currentTheme);
    }

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
      top: 20,
      left: 20,
      child: Container(
        width: 100,
        height: 100,
        color: Color.fromARGB(44, 0, 0, 0), // Color de fondo del contenedor
        child: Center(
          child: Text(
            '${scanController.labelf}',
            style: TextStyle(
              color: const Color.fromARGB(255, 10, 10, 10), // Color del texto
              fontSize: 20,
            ),
          ),
        ),
      ),
    ),
            ],
          )
          
          : const Center(child: Text("Loading Preview...")) ;
        }
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: double.infinity,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIconButton(Icons.search, Colors.white),
            _buildIconButton(Icons.mic, Colors.white),
            _buildIconButton(Icons.aspect_ratio, Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData iconData, Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blue, // This ensures the button's background remains white
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(iconData, color: color),
        onPressed: () {
          // Add onPressed logic here
        },
      ),
    );
  }
}