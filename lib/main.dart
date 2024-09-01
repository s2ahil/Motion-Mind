import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import 'Screens/MyApp.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (!await FlutterOverlayWindow.isPermissionGranted()) {
    await FlutterOverlayWindow.requestPermission(); // Await permission request
  }
  runApp(MyApp());
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.transparent,
      body: BubbleGridOverlay(),
    ),
  ));
}

class BubbleGridOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBubbleRow(30),
          SizedBox(height: 120), // Add vertical spacing between rows
          _buildBubbleRow(50),
          SizedBox(height: 120), // Add vertical spacing between rows
          _buildBubbleRow(30),
        ],
      ),
    );
  }

  Widget _buildBubbleRow(double middleSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBubble(30),
        SizedBox(width: 80), // Increase horizontal spacing between bubbles
        _buildBubble(middleSize),
        SizedBox(width: 80), // Increase horizontal spacing between bubbles
        _buildBubble(30),
      ],
    );
  }

  Widget _buildBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
    );
  }
}