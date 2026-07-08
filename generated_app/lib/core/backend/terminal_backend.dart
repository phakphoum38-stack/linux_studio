abstract class TerminalBackend {


  Future<void> start();


  void write(
    String data,
  );


  String read();


  void resize(
    int cols,
    int rows,
  );


  Future<void> stop();


}
