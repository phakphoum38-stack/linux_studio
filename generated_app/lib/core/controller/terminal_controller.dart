import '../engine/terminal_engine.dart';
import '../engine/screen_buffer.dart';

import '../input/input_pipeline.dart';
import '../input/keyboard_pipeline.dart';

import '../selection/selection_engine.dart';

import '../clipboard/terminal_clipboard.dart';



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


      refresh();


    };



    await engine.start();


  }









  // =========================
  // Terminal Input
  // =========================


  void send(

    String text,

  ){


    engine.write(
      text,
    );


  }









  void sendKey(

    String key,

  ){


    keyboard.sendKey(
      key,
    );


  }









  // =========================
  // Paste Pipeline
  // =========================


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









  Future<void> pasteClipboard()

  async {


    final text =
        await TerminalClipboard.paste();



    if(text.isNotEmpty){


      paste(
        text,
      );


    }


  }









  // =========================
  // Selection System
  // =========================



  void startSelection(

    int row,

    int col,

  ){


    selection.start(
      row,
      col,
    );


    refresh();

  }








  void updateSelection(

    int row,

    int col,

  ){


    selection.update(
      row,
      col,
    );


    refresh();


  }








  void endSelection(){


    selection.end();


    refresh();


  }









  Future<void> copySelection()

  async {



    final text =
        selection.extract(
          buffer,
        );



    await TerminalClipboard.copy(
      text,
    );


  }









  void clearSelection(){


    selection.clear();


    refresh();


  }









  // =========================
  // Resize
  // =========================


  void resize(

    int cols,

    int rows,

  ){


    engine.resize(
      cols,
      rows,
    );


  }









  // =========================
  // Render
  // =========================


  void refresh(){


    onUpdate?.call();


  }









  Future<void> stop()

  async {


    await engine.kill();


  }



}
