import '../controller/terminal_controller.dart';
import '../engine/screen_buffer.dart';



class TerminalSession {



  late final TerminalController controller;



  late final ScreenBuffer buffer;









  TerminalSession({

    TerminalController? controller,

    ScreenBuffer? buffer,

  })

  {



    this.buffer =

        buffer ??

        ScreenBuffer();






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

    String text,

  )

  {


    controller.write(

      text,

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









  bool get isRunning =>

      controller.isRunning;









  ScreenBuffer get screen =>

      controller.buffer;









  void dispose()

  {


    controller.dispose();


  }



}
