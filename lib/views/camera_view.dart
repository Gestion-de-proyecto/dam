import 'dart:async';

import 'package:camera/camera.dart';
import 'package:dam/controller/scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dam/texto.dart';
import 'package:dam/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_tts/flutter_tts.dart';




class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    late FocusNode searchFocusNode;

    String busqueda = '';
    late FocusNode micFocusNode;
    late FocusNode aspectRatioFocusNode;
    final scanController = ScanController();
    Color backgroundColor = Theme.of(context).bottomAppBarColor;
    final FlutterTts _flutterTts = FlutterTts();

    // ignore: prefer_function_declarations_over_variables
    void toggleTheme() {
      ThemeMode currentTheme = Get.theme!.brightness == Brightness.light
          ? ThemeMode.dark
          : ThemeMode.light;
      Get.changeThemeMode(currentTheme);
    }
        void _showInstructionsDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(Instructions.title),
            content: const Scrollbar(
              child: SingleChildScrollView(
                child: Text(Instructions.content),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }



    Future<void> _checkFirstRun() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

      if (isFirstRun){
        WidgetsBinding.instance.addPostFrameCallback((_){
          _showInstructionsDialog();

        });
        await prefs.setBool('isFirstRun', false);
      }
    }

    Future<void> _showSearchDialog(BuildContext context) async {
      TextEditingController searchController = TextEditingController();
      bool isFound = false;
      bool dialogClosed = false;

      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Buscar'),
            content: TextField(
              controller: searchController,
              decoration: const InputDecoration(hintText: 'Ingrese su búsqueda'),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  dialogClosed = true;
                },
              ),
              TextButton(
                child: const Text('Buscar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      Timer.periodic(Duration(seconds: 1), (timer) {
        if (timer.tick >= 40) {
          if (!isFound) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Objeto no encontrado'),
              ),
            );
          }
          timer.cancel();
        } else {
          String searchText = searchController.text;
          if (searchText == scanController.labelf && !dialogClosed) {
            isFound = true;
            Vibration.vibrate(pattern: [0, 500, 500, 500]);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Encontrado el objeto'),
              ),
            );
            timer.cancel();
          }
        }
      });
    }
  void _speakText(String text) async {
    await _flutterTts.speak(text);
  }
Timer.periodic(Duration(seconds: 30), (timer) {
      _speakText(scanController.labelf);
    });

    
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
          Semantics(
            label: 'Show instructions',
            child: IconButton(
              icon: const Icon(Icons.info_outline),
              color: Colors.white,
              onPressed: _showInstructionsDialog,
              tooltip: 'Mostrar Instrucciones',
            ),
          )
        ],
      ),
      body: GetBuilder<ScanController>(

          init: scanController,
          builder: (controller) {
            return controller.isCameraInicialized.value
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: CameraPreview(controller.cameraController),
                      ),
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.deepPurple, width: 4.0),
                          ),
                          child: Center(
                              child: Text(
                            '${scanController.labelf}',
                            
                            style: TextStyle(
                              color: const Color.fromARGB(255, 10, 10, 10),
                              fontSize: 20,
                            ),
                          )),
                        ),
                      )
                    ],
                  )
                : const Center(child: Text("Loading Preview..."));
          }),

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
                      onPressed: () {
                        _showSearchDialog(context);
                      },
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
                    color: aspectRatioFocusNode.hasFocus
                        ? Colors.grey
                        : const Color.fromRGBO(33, 150, 243, 1),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Semantics(
                    label: 'Text Button',
                    child: IconButton(
                      icon: const Icon(Icons.library_books_outlined,
                          color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                        );
                      },
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