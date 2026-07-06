import 'package:flutter/material.dart';
import 'screens/terminal_screen.dart';

void main() {
  runApp(const LinuxStudioApp());
}

class LinuxStudioApp extends StatelessWidget {
  const LinuxStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: TerminalScreen(),
      ),
    );
  }
}
