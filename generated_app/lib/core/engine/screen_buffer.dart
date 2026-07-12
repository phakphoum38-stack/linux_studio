import 'dart:async';

import 'package:flutter/foundation.dart';

import 'terminal_cell.dart';

class TerminalCursor {
  TerminalCursor({this.row = 0, this.col = 0});

  int row;
  int col;
  bool visible = true;
  Timer? _timer;

  void startBlink(VoidCallback update) {
    stopBlink();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      visible = !visible;
      update();
    });
  }

  void stopBlink() {
    _timer?.cancel();
    _timer = null;
    visible = true;
  }
}

class ScreenBuffer {
  ScreenBuffer({this.rows = 24, this.cols = 80}) {
    _createBuffer();
  }

  int rows;
  int cols;
  late List<List<TerminalCell>> _buffer;
  final TerminalCursor cursor = TerminalCursor();

  int currentForeground = 37;
  int currentBackground = 40;
  bool bold = false;
  bool italic = false;
  bool underline = false;
  bool inverse = false;

  List<List<TerminalCell>> get buffer => _buffer;
  List<String> get lines => _buffer
      .map((row) => row.map((cell) => cell.char).join())
      .toList(growable: false);

  void _createBuffer() {
    _buffer = List.generate(
      rows,
      (_) => List.generate(cols, (_) => TerminalCell()),
    );
  }

  bool inBounds(int row, int col) =>
      row >= 0 && row < rows && col >= 0 && col < cols;

  TerminalCell cellAt(int row, int col) {
    if (!inBounds(row, col)) return TerminalCell();
    return _buffer[row][col];
  }

  void resize(int newRows, int newCols) {
    if (newRows <= 0 || newCols <= 0) return;
    final old = _buffer;
    final oldRows = rows;
    final oldCols = cols;
    rows = newRows;
    cols = newCols;
    _createBuffer();

    final copyRows = oldRows < rows ? oldRows : rows;
    final copyCols = oldCols < cols ? oldCols : cols;
    for (var r = 0; r < copyRows; r++) {
      for (var c = 0; c < copyCols; c++) {
        _buffer[r][c] = old[r][c].copy();
      }
    }

    cursor.row = cursor.row.clamp(0, rows - 1);
    cursor.col = cursor.col.clamp(0, cols - 1);
  }

  void writeText(String text) {
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      switch (char) {
        case '\n':
          cursorDown();
          carriageReturn();
          break;
        case '\r':
          carriageReturn();
          break;
        case '\b':
          cursorBack();
          break;
        case '\t':
          tab();
          break;
        default:
          putChar(char);
      }
    }
  }

  void writeChar(String char) => putChar(char);

  void putChar(String char) {
    if (rows <= 0 || cols <= 0 || char.isEmpty) return;
    if (cursor.row >= rows) scrollUp();
    if (cursor.col >= cols) {
      cursor.col = 0;
      cursor.row++;
      if (cursor.row >= rows) scrollUp();
    }

    final cell = _buffer[cursor.row][cursor.col];
    cell
      ..char = char
      ..foreground = currentForeground
      ..background = currentBackground
      ..bold = bold
      ..italic = italic
      ..underline = underline
      ..inverse = inverse;
    cursor.col++;
  }

  void cursorDown([int amount = 1]) {
    cursor.row += amount;
    while (cursor.row >= rows) {
      scrollUp();
    }
  }

  void cursorBack([int amount = 1]) {
    cursor.col = (cursor.col - amount).clamp(0, cols - 1);
  }

  void carriageReturn() => cursor.col = 0;

  void tab([int width = 8]) {
    final next = ((cursor.col ~/ width) + 1) * width;
    cursor.col = next.clamp(0, cols - 1);
  }

  void scroll() => scrollUp();

  void scrollUp([int count = 1]) {
    for (var i = 0; i < count; i++) {
      if (_buffer.isNotEmpty) _buffer.removeAt(0);
      _buffer.add(List.generate(cols, (_) => TerminalCell()));
    }
    cursor.row = rows - 1;
  }

  void scrollDown([int count = 1]) {
    for (var i = 0; i < count; i++) {
      if (_buffer.isNotEmpty) _buffer.removeLast();
      _buffer.insert(0, List.generate(cols, (_) => TerminalCell()));
    }
    cursor.row = cursor.row.clamp(0, rows - 1);
  }

  void clear() {
    _createBuffer();
    cursor.row = 0;
    cursor.col = 0;
    resetStyle();
  }

  void clearLine(int row) {
    if (row < 0 || row >= rows) return;
    _buffer[row] = List.generate(cols, (_) => TerminalCell());
  }

  void eraseToEndOfLine() {
    if (!inBounds(cursor.row, cursor.col)) return;
    for (var col = cursor.col; col < cols; col++) {
      _buffer[cursor.row][col] = TerminalCell();
    }
  }

  void eraseToBeginningOfLine() {
    if (cursor.row < 0 || cursor.row >= rows) return;
    final end = cursor.col.clamp(0, cols - 1);
    for (var col = 0; col <= end; col++) {
      _buffer[cursor.row][col] = TerminalCell();
    }
  }

  void eraseToEndOfScreen() {
    eraseToEndOfLine();
    for (var row = cursor.row + 1; row < rows; row++) {
      clearLine(row);
    }
  }

  void eraseToBeginningOfScreen() {
    for (var row = 0; row < cursor.row; row++) {
      clearLine(row);
    }
    eraseToBeginningOfLine();
  }

  void insertChar() {
    if (!inBounds(cursor.row, cursor.col)) return;
    final line = _buffer[cursor.row];
    line.insert(cursor.col, TerminalCell());
    if (line.length > cols) line.removeLast();
  }

  void deleteChar() {
    if (!inBounds(cursor.row, cursor.col)) return;
    final line = _buffer[cursor.row];
    line.removeAt(cursor.col);
    line.add(TerminalCell());
  }

  void resetStyle() {
    currentForeground = 37;
    currentBackground = 40;
    bold = false;
    italic = false;
    underline = false;
    inverse = false;
  }

  void dispose() => cursor.stopBlink();
}
