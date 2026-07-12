import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

import '../core/controller/terminal_controller.dart'
    as app;



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

  String? _startupError;









  @override
  void initState()
  {

    super.initState();



    controller =
        app.TerminalController();






    terminal = Terminal(

      maxLines: 10000,



      onResize:

          (

            int width,

            int height,

            int pixelWidth,

            int pixelHeight,

          )

          {


            controller.resize(

              width,

              height,

            );


          },

    );








    terminal.onOutput =

        (data)

        {

          controller.write(
            data,
          );


        };









    controller.onUpdate =

        ()

        {


          if(!_disposed)

          {

            _renderBuffer();

          }


        };







    _start();


  }









  Future<void> _start()

  async {

    try {
      await controller.start();

    } catch (error) {
      if (!_disposed && mounted) {
        setState(() {
          _startupError = error.toString();
        });
      }
      return;
    }



    terminal.write(

      'Linux Studio Terminal v2\r\n',

    );


    terminal.write(

      'Starting shell...\r\n\r\n',

    );



    _renderBuffer();


  }









  void _renderBuffer()

  {


    if(_disposed)
    {
      return;
    }





    terminal.write('\x1B[2J\x1B[H');



    for(final line in controller.buffer.lines)

    {

      terminal.write(

        '$line\r\n',

      );


    }


  }









  @override
  Widget build(

    BuildContext context,

  )

  {


    return Scaffold(

      appBar:

          AppBar(

            title:

                const Text(

                  'Linux Studio Terminal v2',

                ),

          ),





      body: _startupError == null
          ? TerminalView(
              terminal,
              autofocus: true,
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to start the terminal.\n\n$_startupError',
                  textAlign: TextAlign.center,
                ),
              ),
            ),


    );


  }









  @override
  void dispose()

  {


    _disposed = true;



    controller.stop();



    super.dispose();


  }



}
