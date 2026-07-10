import 'dart:async';

import '../engine/terminal_engine.dart';
import '../engine/screen_buffer.dart';

import '../backend/terminal_backend.dart';
import '../backend/pty_terminal_backend.dart';

import '../engine/input_pipeline.dart';
import '../input/keyboard_pipeline.dart';

import '../engine/selection_engine.dart';

import '../clipboard/terminal_clipboard.dart';

import '../terminal/terminal_size.dart';



class TerminalController {


  late final TerminalEngine engine;


  late ScreenBuffer buffer;



  final InputPipeline input =
      InputPipeline();



  final KeyboardPipeline keyboard =
      KeyboardPipeline();



  final SelectionEngine selection =
      SelectionEngine();





  Function()? onUpdate;



  TerminalSize? terminalSize;



  int _lastCols = 0;

  int _lastRows = 0;



  bool _running = false;



  bool get isRunning =>
      _running;









  TerminalController({

    TerminalEngine? engine,

    ScreenBuffer? buffer,

    TerminalBackend? backend,

  })

  {


    this.engine =

        engine ??

        TerminalEngine(

          backend:
              backend ??
              PtyTerminalBackend(),


          buffer:
              buffer ??
              ScreenBuffer(),

        );




    this.buffer =
        this.engine.buffer;






    keyboard.onInput =

        (data)

        {

          write(data);

        };


  }









  Future<void> start()

  async {


    engine.onUpdate =

        ()

        {

          refresh();

        };





    await engine.start();



    _running = true;


  }









  void write(

    String text,

  )

  {


    if(!_running)
    {
      return;
    }



    engine.write(

      text,

    );


  }









  void send(

    String text,

  )

  {

    write(text);

  }









  void sendKey(

    String key,

  )

  {

    keyboard.sendKey(
      key,
    );

  }









  void paste(

    String text,

  )

  {


    input.add(text);



    final data =

        input.flush();



    if(data.isNotEmpty)

    {

      write(data);

    }


  }









  Future<void> pasteClipboard()

  async {


    final text =

        await TerminalClipboard.paste();



    if(text.isNotEmpty)

    {

      paste(text);

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









  void startSelection(

    int row,

    int col,

  )

  {

    selection.start(

      row,

      col,

    );


    refresh();

  }









  void updateSelection(

    int row,

    int col,

  )

  {

    selection.update(

      row,

      col,

    );


    refresh();

  }









  void endSelection()

  {

    selection.end();


    refresh();

  }









  void clearSelection()

  {

    selection.clear();


    refresh();

  }









  void resize(

    int cols,

    int rows,

  )

  {


    if(cols <= 0 ||
       rows <= 0)

    {

      return;

    }






    if(
      cols == _lastCols &&
      rows == _lastRows
    )

    {

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



  }









  void refresh()

  {

    onUpdate?.call();

  }









  Future<void> stop()

  async {


    if(!_running)
    {
      return;
    }



    _running = false;



    await engine.kill();


  }









  void dispose()

  {

    stop();

  }



}
