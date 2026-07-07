import 'package:flutter/material.dart';

import '../core/engine/screen_buffer.dart';
import '../core/render/terminal_painter.dart';



class TerminalView extends StatefulWidget {


  final ScreenBuffer buffer;



  const TerminalView({

    super.key,

    required this.buffer,

  });




  @override
  State<TerminalView> createState()
      => _TerminalViewState();

}






class _TerminalViewState
    extends State<TerminalView> {



  @override
  void initState(){

    super.initState();



    widget.buffer.cursor.startBlink(

      (){

        if(mounted){

          setState((){});

        }

      },

    );

  }







  @override
  void dispose(){

    widget.buffer.cursor.stopBlink();


    super.dispose();

  }







  @override
  Widget build(
    BuildContext context,
  ){

    return CustomPaint(

      painter:

        TerminalPainter(

          buffer:
              widget.buffer,

          cursorVisible:

              widget.buffer
              .cursor
              .visible,

        ),


      child:

        Container(),

    );

  }


}
