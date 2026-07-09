import 'dart:async';

import '../backend/native_terminal.dart';
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


  final NativeTerminal? nativeTerminal;



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



  Timer? _nativeReader;



  bool _running = false;






  TerminalController({

    TerminalEngine? engine,

    ScreenBuffer? buffer,

    TerminalBackend? backend,

    NativeTerminal? native,

  })

      :

        engine =
            engine ??
            TerminalEngine(
              backend: backend,
              buffer: buffer,
            ),


        nativeTerminal = native

  {


    this.buffer =
        buffer ??
        this.engine.buffer;




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



    _running = true;



    _startNativeReader();


  }









  void _startNativeReader(){


    if(nativeTerminal == null){

      return;

    }



    _nativeReader =
        Timer.periodic(

          const Duration(
            milliseconds: 50,
          ),

          (_) {


            final output =
                nativeTerminal!.read();



            if(output.isNotEmpty){

              engine.write(
                output,
              );

            }


          },

        );


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



    nativeTerminal?.write(
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
  // Resize
  // =========================



  void resize(

    int cols,

    int rows,

  ){


    if(
      cols <= 0 ||
      rows <= 0
    ){

      return;

    }





    if(
      cols == _lastCols &&
      rows == _lastRows
    ){

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



    nativeTerminal?.resize(
      rows: rows,
      cols: cols,
    );



    refresh();


  }









  void refresh(){

    onUpdate?.call();

  }









  Future<void> stop()

  async {


    _running = false;



    _nativeReader?.cancel();



    _nativeReader = null;



    nativeTerminal?.close();



    await engine.kill();


  }







  void dispose(){

    stop();

  }



}
