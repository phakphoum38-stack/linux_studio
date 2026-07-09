import 'dart:async';

abstract class TerminalBackend {
  /// Output stream from terminal.
  Stream<String> get output;

  /// Error stream.
  Stream<String> get errors;

  /// Start backend.
  Future<void> start();

  /// Stop backend.
  Future<void> stop();

  /// Send text to terminal.
  Future<void> write(String text);

  /// Read buffered data immediately.
  String read();

  /// Resize terminal.
  Future<void> resize(
    int cols,
    int rows,
  );
}
