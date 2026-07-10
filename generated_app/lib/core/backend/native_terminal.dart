import 'dart:ffi';

import 'terminal_ffi.dart';

class NativeTerminal {
  NativeTerminal({
    this.rows = 24,
    this.cols = 80,
  });

  final int rows;
  final int cols;

  Pointer<Void>? _handle;

  bool get isOpen =>
      _handle != null &&
      _handle != nullptr;

  bool open() {
    if (isOpen) {
      return true;
    }

    try {
      _handle = TerminalFFI.instance.createSession(
        rows: rows,
        cols: cols,
      );

      return isOpen;
    } catch (_) {
      _handle = nullptr;
      return false;
    }
  }

  bool write(
    String text,
  ) {
    if (!isOpen) {
      return false;
    }

    return TerminalFFI.instance.writeText(
      _handle!,
      text,
    );
  }

  String read([
    int bufferSize = 8192,
  ]) {
    if (!isOpen) {
      return '';
    }

    return TerminalFFI.instance.readText(
      _handle!,
      bufferSize: bufferSize,
    );
  }

  bool resize({
    required int rows,
    required int cols,
  }) {
    if (!isOpen) {
      return false;
    }

    return TerminalFFI.instance.resizeTerminal(
      _handle!,
      rows: rows,
      cols: cols,
    );
  }

  void close() {
    if (!isOpen) {
      return;
    }

    TerminalFFI.instance.closeTerminal(
      _handle!,
    );

    _handle = nullptr;
  }

  void dispose() {
    close();
  }
}
