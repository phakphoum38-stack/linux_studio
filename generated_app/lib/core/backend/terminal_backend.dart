import 'dart:async';



abstract class TerminalBackend {



  /// stream ข้อมูลจาก terminal

  Stream<String> get output;





  /// stream error

  Stream<String> get errors;









  /// เปิด terminal session

  Future<void> start();









  /// ปิด terminal

  Future<void> stop();









  /// ส่ง keyboard input

  Future<void> write(

    String text,

  );









  /// อ่านข้อมูลทันที

  String read();









  /// เปลี่ยนขนาด terminal

  Future<void> resize(

    int cols,

    int rows,

  );



}
