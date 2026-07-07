import 'package:flutter/material.dart';
import '../engine/screen_buffer.dart';



class TerminalPainter
    extends CustomPainter {


  final ScreenBuffer buffer;


  final double fontSize;


  final bool cursorVisible;



  TerminalPainter({

    required this.buffer,

    required this.cursorVisible,

    this.fontSize = 14,

  });






  @override
  void paint(
    Canvas canvas,
    Size size,
  ){


    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = Colors.black,
    );



    final textStyle =
        TextStyle(

          fontFamily:
              'monospace',

          fontSize:
              fontSize,

        );



    final rowHeight =
        fontSize * 1.25;


    final colWidth =
        fontSize * 0.62;







    for(
      int r=0;
      r<buffer.rows;
      r++
    ){

      for(
        int c=0;
        c<buffer.cols;
        c++
      ){



        final cell =
            buffer.buffer[r][c];



        final isCursor =

            cursorVisible &&

            buffer.cursor.row == r &&

            buffer.cursor.col == c;






        final style =
            textStyle.copyWith(

              color:
                  isCursor

                  ? Colors.black

                  : _fg(cell.fg),

              backgroundColor:

                  isCursor

                  ? Colors.white

                  : _bg(cell.bg),

            );







        final tp =
            TextPainter(

              text:
                  TextSpan(

                    text:
                        cell.char,

                    style:
                        style,

                  ),

              textDirection:
                  TextDirection.ltr,

            );



        tp.layout();



        tp.paint(

          canvas,

          Offset(

            c * colWidth,

            r * rowHeight,

          ),

        );

      }

    }

  }








  Color _fg(int v){

    switch(v){

      case 30:
        return Colors.black;

      case 31:
        return Colors.red;

      case 32:
        return Colors.green;

      case 33:
        return Colors.yellow;

      case 34:
        return Colors.blue;

      case 35:
        return Colors.purple;

      case 36:
        return Colors.cyan;

      default:
        return Colors.white;

    }

  }






  Color _bg(int v){

    switch(v){

      case 40:
        return Colors.black;

      case 41:
        return Colors.red;

      case 42:
        return Colors.green;

      case 43:
        return Colors.yellow;

      case 44:
        return Colors.blue;

      default:
        return Colors.transparent;

    }

  }






  @override
  bool shouldRepaint(
      covariant TerminalPainter old
  ){

    return true;

  }


}
