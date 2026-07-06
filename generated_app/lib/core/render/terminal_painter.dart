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
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.black,
    );

    final textStyle = TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      height: 1.0,
      color: Colors.white,
    );

    final rowHeight = fontSize * 1.25;
    final colWidth = fontSize * 0.62;

    for (int r = 0; r < screen.height; r++) {
      for (int c = 0; c < screen.width; c++) {
        final cell = screen.buffer[r][c];

        if (cell.char == ' ') continue;

        final painter = TextPainter(
          text: TextSpan(
            text: cell.char,
            style: textStyle.copyWith(
              color: _ansiColor(cell.fg),
              backgroundColor: _ansiBackground(cell.bg),
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        painter.layout();

        painter.paint(
          canvas,
          Offset(
            c * colWidth,
            r * rowHeight,
          ),
        );
      }
    }
  }

  Color _ansiColor(int ansi) {
    switch (ansi) {
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

  Color _ansiBackground(int ansi) {
    switch (ansi) {
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
    return true;
  }
}
