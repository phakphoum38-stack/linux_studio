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
  void paint(
    Canvas canvas,
    Size size,
  ) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.black,
    );

    final baseStyle = TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
      color: Colors.white,
    );

    final rowHeight = fontSize * 1.25;
    final colWidth = fontSize * 0.62;

    for (int row = 0; row < screen.rows; row++) {
      for (int col = 0; col < screen.cols; col++) {
        final cell = screen.buffer[row][col];

        if (cell.char == ' ') {
          continue;
        }

        final textPainter = TextPainter(
          text: TextSpan(
            text: cell.char,
            style: baseStyle.copyWith(
              color: _ansiColor(cell.fg),
              backgroundColor: _ansiBg(cell.bg),
              fontWeight: cell.bold
                  ? FontWeight.bold
                  : FontWeight.normal,
              decoration: cell.underline
                  ? TextDecoration.underline
                  : TextDecoration.none,
              fontStyle: cell.italic
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        textPainter.paint(
          canvas,
          Offset(
            col * colWidth,
            row * rowHeight,
          ),
        );
      }
    }
  }


  Color _ansiColor(
    int value,
  ) {
    switch (value) {
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


  Color _ansiBg(
    int value,
  ) {
    switch (value) {
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
  bool shouldRepaint(
    covariant TerminalPainter oldDelegate,
  ) {
    return true;
  }
}
