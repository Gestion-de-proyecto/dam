import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }

    Color backgroundColor = Theme.of(context).bottomAppBarColor;

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
              onPressed: widget.toggleTheme,
              tooltip: 'Cambiar tema',
            ),
          ),
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
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue,
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
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue,
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
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue,
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
          ],
        ),
      ),
    );
  }
}
