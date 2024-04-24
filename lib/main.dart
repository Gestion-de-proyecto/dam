import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
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
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
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

  const MainPage({Key? key, required this.cameras, required this.toggleTheme}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
    );

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

    // Keep button colors constant, only adjust the bar's background
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
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
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
                ),
              ),
            ),
          ),
        ],
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
