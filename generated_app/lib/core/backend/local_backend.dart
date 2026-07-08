import 'terminal_backend.dart';



class LocalBackend
    implements TerminalBackend {


  final List<String> _buffer = [];



  bool _running = false;




  @override
  Future<void> start()

  async {

    _running = true;

  }






  @override
  void write(
    String data,
  ){

    if(!_running){

      return;

    }


    _buffer.add(
      data,
    );

  }







  @override
  String read(){

    if(_buffer.isEmpty){

      return '';

    }


    final data =
        _buffer.join();



    _buffer.clear();



    return data;

  }







  @override
  void resize(
    int cols,
    int rows,
  ){

    // local backend no resize

  }







  @override
  Future<void> stop()

  async {

    _running = false;

    _buffer.clear();

  }


}
