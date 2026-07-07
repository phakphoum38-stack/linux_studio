import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'ansi_csi_parser.dart';
import 'screen_buffer.dart';
import 'vt100_state_machine.dart';



class TerminalEngine {


  Process? _process;


  final ScreenBuffer buffer;


  final AnsiCsiParser parser =
      AnsiCsiParser();



  late final VT100StateMachine vt100;



  Function()? onUpdate;



  TerminalEngine({
    required this.buffer,
  }) {

    vt100 =
        VT100StateMachine(
          buffer,
        );

  }






  Future<void> start() async {


    _process =
        await Process.start(
          'bash',
          [
            '-i',
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
        parser.parse(
          data,
        );



    for(final event in events){

      vt100.handle(
        event,
      );

    }



    onUpdate?.call();

  }









  void write(
    String input,
  ){

    if(_process == null){

      return;

    }



    _process!
        .stdin
        .write(
          input,
        );


    _process!
        .stdin
        .flush();

  }









  void sendKey(
    String key,
  ){

    write(key);

  }









  void resize(
    int cols,
    int rows,
  ){

    //
    // Phase 16.6
    // real PTY resize
    //


  }









  Future<void> kill()
  async {


    await _process
        ?.stdin
        .flush();



    _process?.kill(
      ProcessSignal.sigkill,
    );


    _process=null;


  }

}
