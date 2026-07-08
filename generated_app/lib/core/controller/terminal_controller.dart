import '../engine/terminal_engine.dart';
import '../engine/screen_buffer.dart';
import '../backend/terminal_backend.dart';

import '../engine/input_pipeline.dart';
import '../input/keyboard_pipeline.dart';

import '../engine/selection_engine.dart';

import '../clipboard/terminal_clipboard.dart';

import '../terminal/terminal_size.dart';



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



  TerminalSize? terminalSize;



  int _lastCols = 0;
  int _lastRows = 0;






  TerminalController({

    TerminalEngine? engine,

    ScreenBuffer? buffer,

    TerminalBackend? backend,

  }) : engine =
            engine ??
            TerminalEngine(
              backend: backend,
              buffer: buffer,
            ) {

    this.buffer =
        buffer ?? this.engine.buffer;


    keyboard.onInput =
        (data){

      send(data);

    };


  }









  Future<void> start([

    ScreenBuffer? screen,

    Function()? render,

  ])

  async {


    if(screen != null){

      buffer = screen;

    }


    if(render != null){

      onUpdate = render;

    }



    engine.onUpdate =
        (){


      refresh();


    };



    await engine.start();


  }









  // =========================
  // Input
  // =========================


  void send(

    String text,

  ){

    if(text.isEmpty){

      return;

    }


    engine.write(
      text,
    );

  }







  void write(

    String text,

  ){

    send(
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
  // Clipboard
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









  // =========================
  // Selection
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







  void clearSelection(){


    selection.clear();


    refresh();

  }









  // =========================
  // Terminal Resize
  // =========================


  void resize(

    int cols,

    int rows,

  ){



    if(cols <= 0 ||
       rows <= 0){

      return;

    }




    if(cols == _lastCols &&
       rows == _lastRows){

      return;

    }




    _lastCols = cols;
    _lastRows = rows;



    terminalSize =
        TerminalSize(
          cols: cols,
          rows: rows,
        );



    engine.resize(
      cols,
      rows,
    );



    refresh();

  }









  void refresh(){

    onUpdate?.call();

  }









  Future<void> stop()

  async {


    await engine.kill();


  }



}
