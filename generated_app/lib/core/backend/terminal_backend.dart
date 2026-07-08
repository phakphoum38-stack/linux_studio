import 'dart:async';

abstract class TerminalBackend {
  /// Terminal output stream
  Stream<String> get output;

  /// Terminal error stream
  Stream<String> get errors;

  /// Start backend
  Future<void> start();

  /// Stop backend
  Future<void> stop();

  /// Send text to terminal
  Future<void> write(String text);

  /// Read immediately if available.
  ///
  /// Native backends may return buffered data.
  /// Stream listeners should normally use [output].
  String read();

  /// Resize terminal
  Future<void> resize(
    int cols,
    int rows,
  );
}
