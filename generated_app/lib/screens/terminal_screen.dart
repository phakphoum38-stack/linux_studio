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


  late final Terminal xterm;


  late final app.TerminalController controller;



  @override
  void initState(){

    super.initState();



    xterm =
        Terminal(
          maxLines: 10000,
        );



    controller =
        app.TerminalController();



    xterm.onOutput =
        (data){

      controller.write(
        data,
      );

    };



    _start();

  }






  Future<void> _start()
  async {

    await controller.start();

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

          xterm,

          autofocus: true,

        ),

    );

  }







  @override
  void dispose(){


    controller.dispose();


    super.dispose();


  }


}
