import 'package:flutter/material.dart';
import '../engine/screen_buffer.dart';

class TerminalPainter extends CustomPainter {
  final ScreenBuffer screen;

  final double fontSize;
  final String fontFamily;

  TerminalPainter(
    this.screen, {
    this.fontSize = 14,
    this.fontFamily = 'monospace',
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.black;

    canvas.drawRect(Offset.zero & size, bgPaint);

    final textStyle = TextStyle(
      color: Colors.greenAccent,
      fontSize: fontSize,
      fontFamily: fontFamily,
    );

    final rowHeight = fontSize * 1.25;
    final colWidth = fontSize * 0.62;

    for (int r = 0; r < screen.rows; r++) {
      for (int c = 0; c < screen.cols; c++) {
        final cell = screen.buffer[r][c];

        if (cell.char == ' ') continue;

        final painter = TextPainter(
          text: TextSpan(
            text: cell.char,
            style: textStyle.copyWith(
              color: _ansiColor(cell.foreground),
              backgroundColor: _ansiBg(cell.background),
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        painter.layout();

        painter.paint(
          canvas,
          Offset(c * colWidth, r * rowHeight),
        );
      }
    }
  }

  Color _ansiColor(int v) {
    switch (v) {
      case 30:
        return Colors.black;
      case 31:
        return Colors.red;
      case 32:
        return Colors.green;
      case 33:
        return Colors.yellow;
      case 34:
        return Colors.blue;
      case 35:
        return Colors.purple;
      case 36:
        return Colors.cyan;
      case 37:
      default:
        return Colors.white;
    }
  }

  Color _ansiBg(int v) {
    switch (v) {
      case 40:
        return Colors.black;
      case 41:
        return Colors.red;
      case 42:
        return Colors.green;
      case 43:
        return Colors.yellow;
      case 44:
        return Colors.blue;
      case 45:
        return Colors.purple;
      case 46:
        return Colors.cyan;
      case 47:
        return Colors.white;
      default:
        return Colors.transparent;
    }
  }

  @override
  bool shouldRepaint(covariant TerminalPainter oldDelegate) {
    return oldDelegate.screen != screen;
  }
}
