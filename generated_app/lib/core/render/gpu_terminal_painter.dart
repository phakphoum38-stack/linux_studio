import 'package:flutter/material.dart';
import '../engine/screen_buffer.dart';

class GpuTerminalPainter extends CustomPainter {
  final ScreenBuffer buffer;

  GpuTerminalPainter(this.buffer);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final cellW = size.width / buffer.cols;
    final cellH = size.height / buffer.rows;

    for (int y = 0; y < buffer.rows; y++) {
      for (int x = 0; x < buffer.cols; x++) {
        final c = buffer.buffer[y][x];

        textPainter.text = TextSpan(
          text: c.char,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
          ),
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x * cellW, y * cellH),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
