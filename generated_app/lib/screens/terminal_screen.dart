import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

import '../core/controller/terminal_controller.dart';



class TerminalScreen extends StatefulWidget {

  const TerminalScreen({
    super.key,
  });


  @override
  State<TerminalScreen> createState()
      => _TerminalScreenState();

}




class _TerminalScreenState
    extends State<TerminalScreen> {


  late Terminal xterm;

  late TerminalController controller;



  @override
  void initState(){

    super.initState();


    xterm =
        Terminal(
          maxLines: 10000,
        );



    controller =
        TerminalController();



    xterm.onOutput =
        (data){

          controller.write(
            data,
          );

        };



    controller.start();


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


    controller.stop();


    super.dispose();


  }


}
