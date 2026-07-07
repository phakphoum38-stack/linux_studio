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
  State<TerminalView> createState() =>
      _TerminalViewState();
}



class _TerminalViewState
    extends State<TerminalView> {



  @override
  Widget build(
    BuildContext context,
  ) {

    return Container(

      color: Colors.black,

      child: CustomPaint(

        painter: TerminalPainter(
          widget.buffer,
        ),


        child: SizedBox.expand(),
      ),
    );
  }
}
