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


  late Terminal terminal;

  late app.TerminalController controller;



  @override
  void initState(){

    super.initState();


    terminal = Terminal(
      maxLines: 10000,
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

      final text =
          controller.buffer.toString();


      terminal.write(
        text,
      );

    };



    controller.start();


  }





  @override
  Widget build(
    BuildContext context,
  ){

    return Scaffold(

      appBar: AppBar(
        title:
          const Text(
            'Linux Studio Terminal',
          ),
      ),


      body:

        TerminalView(

          terminal,

          autofocus:true,

        ),

    );

  }




  @override
  void dispose(){

    controller.stop();

    super.dispose();

  }

}
