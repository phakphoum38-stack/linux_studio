import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

import '../core/controller/terminal_controller.dart' as app;



class TerminalScreen extends StatefulWidget {

  const TerminalScreen({
    super.key,
  });


  @override
  State<TerminalScreen> createState() =>
      _TerminalScreenState();

}



class _TerminalScreenState
    extends State<TerminalScreen> {


  late final Terminal terminal;

  late final app.TerminalController controller;


  bool _disposed = false;



  @override
  void initState() {

    super.initState();


    terminal = Terminal(
      maxLines: 10000,

      onResize: (
        width,
        height,
      ){

        controller.resize(
          width,
          height,
        );

      },

    );



    controller =
        app.TerminalController();



    terminal.onOutput =
        (data){

      controller.write(
        data,
      );

    };



    controller.onUpdate =
        (){

      if(!_disposed){

        _renderBuffer();

      }

    };



    _start();

  }






  Future<void> _start()
  async {


    await controller.start();


    terminal.write(
      'Linux Studio Terminal\r\n',
    );


    terminal.write(
      'Starting shell...\r\n\r\n',
    );


    _renderBuffer();

  }







  void _renderBuffer(){

    if(_disposed){

      return;

    }



    final lines =
        controller.buffer.lines;



    terminal.write(
      '\x1B[2J',
    );


    terminal.write(
      '\x1B[H',
    );



    for(final line in lines){

      terminal.write(
        '$line\r\n',
      );

    }


  }








  @override
  Widget build(
    BuildContext context,
  ){

    return Scaffold(

      appBar:
        AppBar(

          title:
            const Text(
              'Linux Studio Terminal',
            ),

        ),



      body:

        TerminalView(

          terminal,

          autofocus:true,

          backgroundOpacity:1,

        ),

    );

  }








  @override
  void dispose(){

    _disposed = true;


    controller.stop();


    super.dispose();

  }


}
