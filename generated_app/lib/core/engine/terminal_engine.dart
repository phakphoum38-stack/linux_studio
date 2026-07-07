import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'ansi_csi_parser.dart';
import 'screen_buffer.dart';
import 'vt100_controller.dart';


class TerminalEngine {

  Process? _process;


  final ScreenBuffer buffer;


  final AnsiCsiParser parser =
      AnsiCsiParser();


  final VT100Controller vt100 =
      VT100Controller();



  Function()? onUpdate;



  TerminalEngine({
    required this.buffer,
  });



  Future<void> start() async {


    _process =
        await Process.start(
          'bash',
          [
            '-i'
          ],
          runInShell: true,
        );



    _process!
        .stdout
        .transform(
          utf8.decoder,
        )
        .listen(
          _handleOutput,
        );



    _process!
        .stderr
        .transform(
          utf8.decoder,
        )
        .listen(
          _handleOutput,
        );

  }






  void _handleOutput(
    String data,
  ){

    final events =
        parser.parse(data);



    for(final event in events){

      if(event is String){

        buffer.writeText(
          event,
        );


      }

      else {

        vt100.execute(
          event.command,
          event.args,
          buffer,
        );

      }

    }


    onUpdate?.call();

  }






  void write(
    String input,
  ){

    if(_process == null)
      return;


    _process!
        .stdin
        .write(
          input,
        );

  }





  void resize(
    int cols,
    int rows,
  ){

    // Phase 16.2
    // PTY resize


  }





  Future<void> kill()
  async {

    _process?.kill();

    _process=null;

  }

}
