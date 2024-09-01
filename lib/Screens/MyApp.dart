import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../main.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motion Mind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  bool _overlayVisible = false;
  StreamSubscription? _accelerometerSubscription;
  String _displayText = 'Turn on to activate travel sickness removal mode.';

  void _toggleOverlay() async {
    if (_overlayVisible) {
      await FlutterOverlayWindow.closeOverlay();
      _stopListeningToSensors();
      setState(() {
        _displayText = 'Turn on 🔛 to activate travel sickness removal mode.';
      });
    } else {
      await FlutterOverlayWindow.showOverlay(
        height: -1,
        width: -1,
        flag: OverlayFlag.clickThrough,
      );
      _startListeningToSensors();
      setState(() {
        _displayText = 'Travel Mode On 💡 Have a great ride!';
      });
    }

    setState(() {
      _overlayVisible = !_overlayVisible;
    });
  }

  void _startListeningToSensors() {
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      double x = -event.x * 50; // Adjust these values based on your needs
      double y = -event.y * 2;
      FlutterOverlayWindow.moveOverlay(OverlayPosition(x, y));
    });
  }

  void _stopListeningToSensors() {
    _accelerometerSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double calcFontSize = screenWidth * 0.06;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF071952),
        title: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 9.0),
              child: Text(
                'Motion Mind',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Spacer(),PopupMenuButton<String>(
              icon: Icon(Icons.settings, color: Colors.white),
              onSelected: (value) {
                if (value == 'About App') {
                  _showAboutDialog(context);
                } else if (value == 'Contact Email') {
                  _showContactEmail(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return {'About App', 'Contact Email'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFF088395),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              _displayText,
              style: TextStyle(fontSize: calcFontSize,color: Colors.white),

            ),
            SizedBox(height: 60.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0), // Adjust the value to get the desired curve
              child: Image.asset('lib/Images/Car.png'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleOverlay,
        tooltip: _overlayVisible ? 'Stop Overlay' : 'Start Overlay',
        child: Icon(
          _overlayVisible ? Icons.stop : Icons.play_arrow,
        ),
      ),
    );
  }
  @override
  void dispose() {
    _stopListeningToSensors();
    super.dispose();
  }
}

void _showAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('About App'),
        content: Text('Motion Mind helps you avoid travel sickness by providing a visual aid that reduces dizziness while traveling. you can read or watch in your mobile phone without feeling bad.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _showContactEmail(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Contact Email'),
        content: Text('You can contact us at: sahiluniverse1@gmail.com or ry4442015@gmail.com'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}