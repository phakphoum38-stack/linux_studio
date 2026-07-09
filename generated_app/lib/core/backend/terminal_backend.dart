import 'dart:async';

abstract class TerminalBackend {
  /// Output stream
  Stream<String> get output;

  /// Error stream
  Stream<String> get errors;

  /// Start terminal backend
  Future<void> start();

  /// Stop terminal backend
  Future<void> stop();

  /// Write text to terminal
  Future<void> write(
    String text,
  );

  /// Read buffered output (optional)
  String read();

  /// Resize terminal
  Future<void> resize(
    int cols,
    int rows,
  );
}
