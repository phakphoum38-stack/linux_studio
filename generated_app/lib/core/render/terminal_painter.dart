import 'package:flutter/material.dart';

import '../engine/screen_buffer.dart';


class TerminalPainter
    extends CustomPainter {


  final ScreenBuffer screen;


  final double fontSize;

  final String fontFamily;



  TerminalPainter(
    this.screen, {

    this.fontSize = 14,

    this.fontFamily = 'monospace',
  });



  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {


    canvas.drawRect(
      Offset.zero & size,

      Paint()
        ..color = Colors.black,
    );



    final style = TextStyle(

      fontSize: fontSize,

      fontFamily: fontFamily,

      color: Colors.white,
    );



    final rowHeight =
        fontSize * 1.25;


    final colWidth =
        fontSize * 0.62;



    for (int r = 0;
        r < screen.rows;
        r++) {



      for (int c = 0;
          c < screen.cols;
          c++) {



        final cell =
            screen.buffer[r][c];



        final cursor =
            screen.cursor.row == r &&
            screen.cursor.col == c;



        final painter =
            TextPainter(

          text: TextSpan(

            text: cell.char,

            style: style.copyWith(

              color:
                  _fg(cell.fg),

              backgroundColor:
                  cursor
                      ? Colors.white
                      : _bg(cell.bg),
            ),
          ),


          textDirection:
              TextDirection.ltr,
        );



        painter.layout();



        painter.paint(

          canvas,

          Offset(
            c * colWidth,
            r * rowHeight,
          ),
        );
      }
    }
  }




  Color _fg(
    int code,
  ) {

    switch(code) {

      case 31:
        return Colors.red;

      case 32:
        return Colors.green;

      case 33:
        return Colors.yellow;

      case 34:
        return Colors.blue;

      case 36:
        return Colors.cyan;

      default:
        return Colors.white;
    }
  }




  Color _bg(
    int code,
  ) {

    switch(code) {

      case 41:
        return Colors.red;

      case 42:
        return Colors.green;

      case 44:
        return Colors.blue;

      default:
        return Colors.transparent;
    }
  }



  @override
  bool shouldRepaint(
    covariant TerminalPainter oldDelegate,
  ) {

    return true;
  }
}
