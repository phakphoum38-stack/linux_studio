import 'package:flutter/material.dart';
import '../engine/screen_buffer.dart';

class TerminalPainter extends CustomPainter {
  final ScreenBuffer buffer;

  TerminalPainter(this.buffer);

  Color _mapColor(int code) {
    switch (code) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.blue;
      case 7:
      default:
        return Colors.white;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final cellWidth = size.width / buffer.cols;
    final cellHeight = size.height / buffer.rows;

    for (int r = 0; r < buffer.rows; r++) {
      for (int c = 0; c < buffer.cols; c++) {
        final cell = buffer.buffer[r][c];

        final textSpan = TextSpan(
          text: cell.char,
          style: TextStyle(
            color: _mapColor(cell.fg),
            fontFamily: 'monospace',
            fontSize: cellHeight,
          ),
        );

        textPainter.text = textSpan;
        textPainter.layout();

        textPainter.paint(
          canvas,
          Offset(c * cellWidth, r * cellHeight),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
