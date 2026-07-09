import '../engine/terminal_engine.dart';
import '../engine/screen_buffer.dart';
import '../scroll/scrollback_buffer.dart';
import '../scroll/terminal_scroll_controller.dart';
import '../render/diff_renderer.dart';


class TerminalSession {


  final TerminalEngine engine =
      TerminalEngine();



  late ScreenBuffer screen;



  final ScrollbackBuffer scrollback =
      ScrollbackBuffer();



  late TerminalScrollController scroll;



  final DiffRenderer diff =
      DiffRenderer();



  Function()? onUpdate;






  TerminalSession(){

    scroll =
        TerminalScrollController(
          scrollback,
        );

  }








  Future<void> start(
    ScreenBuffer buffer,
    Function() render,
  ) async {


    screen = buffer;

    onUpdate = render;



    engine.onUpdate =
        () {


      onUpdate?.call();


    };



    await engine.start();


  }









  void write(
    String input,
  ){


    if(input.isEmpty){

      return;

    }



    engine.write(
      input,
    );


  }








  // ===================
  // Scroll Control
  // ===================



  void scrollUp(){

    scroll.scrollUp(
      3,
    );


    onUpdate?.call();

  }






  void scrollDown(){

    scroll.scrollDown(
      3,
    );


    onUpdate?.call();

  }







  void pageUp(){

    scroll.pageUp();


    onUpdate?.call();

  }







  void pageDown(){

    scroll.pageDown();


    onUpdate?.call();

  }







  void scrollToBottom(){

    scroll.bottom();


    onUpdate?.call();

  }








  Future<void> kill()

  async {


    await engine.kill();


  }


}
