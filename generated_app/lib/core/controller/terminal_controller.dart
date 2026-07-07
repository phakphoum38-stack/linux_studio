import '../engine/terminal_engine.dart';
import '../engine/screen_buffer.dart';

import '../input/input_pipeline.dart';
import '../input/keyboard_pipeline.dart';

import '../selection/selection_engine.dart';



class TerminalController {



  final TerminalEngine engine;



  final InputPipeline input =
      InputPipeline();



  final KeyboardPipeline keyboard =
      KeyboardPipeline();



  final SelectionEngine selection =
      SelectionEngine();




  late ScreenBuffer buffer;



  Function()? onUpdate;





  TerminalController({

    required this.engine,

  }) {


    keyboard.onInput =
        (data){

      send(data);

    };


  }








  Future<void> start(

    ScreenBuffer screen,

    Function() render,

  )

  async {


    buffer = screen;


    onUpdate = render;



    engine.onUpdate =
        (){

      onUpdate?.call();

    };



    await engine.start();


  }








  /// Send raw terminal data

  void send(
    String text,
  ){


    engine.write(
      text,
    );


  }









  /// Keyboard event

  void sendKey(
    String key,
  ){


    keyboard.sendKey(
      key,
    );


  }









  /// Paste support

  void paste(
    String text,
  ){


    input.add(
      text,
    );



    final data =
        input.flush();



    if(data.isNotEmpty){

      send(
        data,
      );

    }


  }









  void refresh(){

    onUpdate?.call();

  }









  void resize(
    int cols,
    int rows,
  ){


    engine.resize(
      cols,
      rows,
    );


  }









  Future<void> stop()

  async {


    await engine.kill();


  }



}
