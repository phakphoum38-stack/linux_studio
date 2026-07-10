import 'dart:async';

abstract class TerminalBackend {
  /// Stream ของข้อมูลจาก Terminal
  Stream<String> get output;

  /// Stream ของ Error
  Stream<String> get errors;

  /// เริ่ม Terminal
  Future<void> start();

  /// ปิด Terminal
  Future<void> stop();

  /// ส่งข้อความเข้า Terminal
  Future<void> write(
    String text,
  );

  /// อ่านข้อมูลทันที (Native)
  String read();

  /// Resize Terminal
  Future<void> resize(
    int cols,
    int rows,
  );

  /// สถานะการทำงาน
  bool get isRunning;
}
