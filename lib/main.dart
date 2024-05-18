import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MainApp(cameras: cameras));
}

class MainApp extends StatefulWidget {
  final List<CameraDescription> cameras;

  const MainApp({Key? key, required this.cameras}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: MainPage(cameras: widget.cameras, toggleTheme: _toggleTheme),
    );
  }
}

class MainPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final VoidCallback toggleTheme;

  const MainPage({Key? key, required this.cameras, required this.toggleTheme})
      : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CameraController _controller;

  late FocusNode searchFocusNode;
  late FocusNode micFocusNode;
  late FocusNode aspectRatioFocusNode;
  
  
  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    searchFocusNode = FocusNode();
    micFocusNode = FocusNode();
    aspectRatioFocusNode = FocusNode();


    _checkFirstRun();
  }

  @override
  void dispose() {
    _controller.dispose();
    searchFocusNode.dispose();
    micFocusNode.dispose();
    aspectRatioFocusNode.dispose();
    super.dispose();
  }

  Future<void> _checkFirstRun() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (isFirstRun){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showInstructionsDialog();
       });

       await prefs.setBool('isFirstRun', false);
    }
  }

  void _showInstructionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(Instructions.title), // Usa la constante para el título
          content: const Scrollbar(
            child: SingleChildScrollView(
              child: Text(Instructions.content), // Usa la constante para el contenido
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


@override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }

    Color backgroundColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(118, 5, 5, 5),
        elevation: 0,
        leading: Image.asset('assets/images/Logo.png'),
        title: const Center(
            child: Text(
          "DAM",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        )),
        actions: [
          Semantics(
            label: 'Change theme',
            child: IconButton(
              icon: const Icon(Icons.brightness_6),
              color: Colors.white,
              onPressed: widget.toggleTheme,
              tooltip: 'Cambiar tema',
            ),
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
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(_controller),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.circle,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    // Add onPressed logic here
                    print("11111111111111111111111");
                  },
                  tooltip: 'Captura',
                ),
              ),
            ),
          ),
        ],
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

