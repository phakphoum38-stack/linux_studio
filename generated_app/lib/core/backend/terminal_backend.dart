import 'dart:async';

abstract class TerminalBackend {
  Stream<String> get output;
  Stream<String> get errors;

  Future<void> start();
  Future<void> stop();
  Future<void> write(String text);
  String read();
  Future<void> resize(int cols, int rows);
}
