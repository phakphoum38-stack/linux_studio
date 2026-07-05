import 'package:flutter/material.dart';
import '../core/engine/screen_buffer.dart';
import '../core/render/terminal_painter.dart';

class TerminalView extends StatelessWidget {
  final ScreenBuffer buffer;

  const TerminalView({super.key, required this.buffer});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TerminalPainter(buffer),
      child: Container(
        color: Colors.black,
      ),
    );
  }
}
