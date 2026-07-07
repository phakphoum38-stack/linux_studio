import 'package:flutter/material.dart';

import '../core/engine/screen_buffer.dart';
import '../core/engine/terminal_engine.dart';
import '../core/engine/terminal_controller.dart';
import '../ui/terminal_view.dart';



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



  late ScreenBuffer buffer;

  late TerminalEngine engine;

  late TerminalController terminal;



  final TextEditingController input =
      TextEditingController();





  @override
  void initState() {

    super.initState();



    buffer = ScreenBuffer(
      rows: 24,
      cols: 80,
    );



    engine = TerminalEngine(
      buffer: buffer,
    );



    terminal = TerminalController(
      engine: engine,
    );



    terminal.start(
      buffer,
      () {

        if(mounted){

          setState(() {});

        }

      },
    );

  }







  void send(
    String text,
  ){

    if(text.isEmpty){
      return;
    }



    terminal.send(
      text,
    );



    terminal.sendKey(
      "ENTER",
    );



    input.clear();

  }








  @override
  void dispose(){

    terminal.stop();

    input.dispose();

    super.dispose();

  }







  @override
  Widget build(
    BuildContext context,
  ){


    return Column(

      children: [



        Expanded(

          child: TerminalView(
            buffer: buffer,
          ),

        ),






        Container(

          color: Colors.black,

          child: TextField(

            controller: input,


            autofocus: true,


            style: const TextStyle(
              color: Colors.white,
              fontFamily: "monospace",
            ),



            decoration:
                const InputDecoration(

                  hintText:
                    "Terminal input",

                  hintStyle:
                    TextStyle(
                      color: Colors.grey,
                    ),

                ),




            onSubmitted: send,

          ),

        ),


      ],

    );

  }

}
