import 'dart:async';





abstract class TerminalBackend {





  /// ข้อมูล output จาก terminal

  Stream<String> get output;







  /// ข้อความ error จาก terminal

  Stream<String> get errors;







  /// สถานะ terminal

  bool get isRunning;







  /// เปิด terminal session

  Future<void> start();







  /// ปิด terminal session

  Future<void> stop();







  /// ส่ง input keyboard

  Future<void> write(

    String text,

  );







  /// อ่านข้อมูลล่าสุด (optional)

  String read();







  /// resize terminal

  Future<void> resize(

    int cols,

    int rows,

  );







  /// cleanup resource

  Future<void> dispose();



}