import 'package:flutter/material.dart';

import 'screens/terminal_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const LinuxStudioApp(),
  );
}

class LinuxStudioApp extends StatelessWidget {
  const LinuxStudioApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linux Studio Terminal v2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const TerminalScreen(),
    );
  }
}
