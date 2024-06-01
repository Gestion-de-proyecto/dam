import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:dam/consts.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(           
                backgroundColor: const Color.fromARGB(255, 33, 150, 243),
                elevation: 0,
                leading: Image.asset('assets/Logo.png'),
                title: const Center(
                  child: Text(
                    "DAM - Reconocimiento de texto",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ))
              ),
      body: HomePage(text: text),
    );
  }
}

class HomePage extends StatefulWidget {
  final String text;

  const HomePage({Key? key, required this.text}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterTts _flutterTts = FlutterTts();
  List<Map<String, String>> _voices = [];
  Map<String, String>? _currentVoice;

  int? _currentWordStart, _currentWordEnd;

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() async {
    _flutterTts.setProgressHandler((String text, int start, int end, String word) {
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });

    var data = await _flutterTts.getVoices;
    try {
      List<Map<String, String>> voices = List<Map<String, String>>.from(data);
      setState(() {
        _voices = voices.where((voice) => voice["name"]!.contains("en")).toList();
        _currentVoice = _voices.first;
        setVoice(_currentVoice!);
      });

      // Llama al método speak aquí para leer el texto automáticamente
      await _flutterTts.awaitSpeakCompletion(true); // Opcional, espera a que la lectura termine
      _speakText(); // Asegúrate de llamar al método speak aquí
    } catch (e) {
      print(e);
    }
  }

  void _speakText() async {
    await _flutterTts.speak(widget.text);
  }

  void setVoice(Map<String, String> voice) {
    _flutterTts.setVoice({"name": voice["name"]!, "locale": voice["locale"]!});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _speakText();
        },
        child: const Icon(Icons.speaker_phone),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _speakerSelector(),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 20,
                color: Colors.black,
              ),
              children: <TextSpan>[
                if (_currentWordStart != null)
                  TextSpan(
                    text: widget.text.substring(0, _currentWordStart!),
                  ),
                if (_currentWordStart != null && _currentWordEnd != null)
                  TextSpan(
                    text: widget.text.substring(_currentWordStart!, _currentWordEnd),
                    style: const TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                if (_currentWordEnd != null)
                  TextSpan(
                    text: widget.text.substring(_currentWordEnd!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _speakerSelector() {
    return DropdownButton<Map<String, String>>(
      value: _currentVoice,
      items: _voices
          .map(
            (voice) => DropdownMenuItem<Map<String, String>>(
              value: voice,
              child: Text(voice["name"]!),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _currentVoice = value;
          if (value != null) {
            setVoice(value);
            _speakText(); // Habla de nuevo si se selecciona una nueva voz
          }
        });
      },
    );
  }
}



/*@override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Text(text),
        ),
      );*/