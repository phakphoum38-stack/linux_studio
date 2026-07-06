import 'package:flutter/material.dart';

/// Represents one cell in the terminal screen.
class TerminalCell {
  String char;

  int foreground;
  int background;

  bool bold;
  bool italic;
  bool underline;
  bool inverse;

  TerminalCell({
    this.char = ' ',
    this.foreground = 37,
    this.background = 40,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.inverse = false,
  });

  TerminalCell copy() {
    return TerminalCell(
      char: char,
      foreground: foreground,
      background: background,
      bold: bold,
      italic: italic,
      underline: underline,
      inverse: inverse,
    );
  }

  void reset() {
    char = ' ';
    foreground = 37;
    background = 40;
    bold = false;
    italic = false;
    underline = false;
    inverse = false;
  }

  Color get foregroundColor {
    switch (foreground) {
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

  Color get backgroundColor {
    switch (background) {
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
        return Colors.black;
    }
  }
}
