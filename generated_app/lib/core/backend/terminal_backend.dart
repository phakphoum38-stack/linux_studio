abstract class TerminalBackend {


  Stream<String> get output;



  Future<void> start();



  void write(
    String data,
  );



  void resize(
    int cols,
    int rows,
  );



  Future<void> kill();


}
