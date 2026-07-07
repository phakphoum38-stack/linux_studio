abstract class TerminalBackend {


  Function(String data)? onOutput;

  Function(String error)? onError;



  Future<void> start();


  void write(String data);


  void resize(
    int cols,
    int rows,
  );


  Future<void> stop();



}
