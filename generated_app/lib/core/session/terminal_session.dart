import '../controller/terminal_controller.dart';
import '../engine/screen_buffer.dart';



class TerminalSession {


  late final TerminalController controller;



  final ScreenBuffer buffer;





  TerminalSession({

    TerminalController? controller,

    ScreenBuffer? buffer,

  })

      : buffer =
            buffer ??
            ScreenBuffer()

  {


    this.controller =

        controller ??

        TerminalController(

          buffer: this.buffer,

        );


  }









  Future<void> start()

  async {


    await controller.start();


  }









  void write(

    String data,

  )

  {


    controller.write(

      data,

    );


  }









  void resize(

    int cols,

    int rows,

  )

  {


    controller.resize(

      cols,

      rows,

    );


  }









  Future<void> stop()

  async {


    await controller.stop();


  }









  bool get running =>

      controller.isRunning;



}
