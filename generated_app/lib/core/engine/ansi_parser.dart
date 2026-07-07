import 'vt100_state_machine.dart';
import 'screen_buffer.dart';



class AnsiParser {


  final VT100StateMachine vt100;



  AnsiParser(
    this.vt100,
  );




  void parse(
    String input,
    ScreenBuffer buffer,
  ) {


    int i = 0;



    while(
      i < input.length
    ) {



      final char =
          input[i];



      if(char == '\x1B') {


        if(
          i + 1 < input.length &&
          input[i+1] == '['
        ) {



          final result =
              _parseCSI(
                input,
                i + 2,
              );



          vt100.process(
            result.command,
            result.args,
            buffer,
          );



          i =
              result.index;


          continue;
        }
      }




      _writeChar(
        char,
        buffer,
      );


      i++;
    }
  }






  void _writeChar(
    String ch,
    ScreenBuffer buffer,
  ) {


    if(ch == '\n') {


      vt100.cursorRow++;


      vt100.cursorCol = 0;


      return;
    }



    if(ch == '\r') {


      vt100.cursorCol = 0;


      return;
    }



    if(
      vt100.cursorRow >= buffer.rows ||
      vt100.cursorCol >= buffer.cols
    ) {

      return;
    }



    final cell =
        buffer.buffer
            [vt100.cursorRow]
            [vt100.cursorCol];



    cell.char = ch;

    cell.fg = vt100.fg;

    cell.bg = vt100.bg;



    vt100.cursorCol++;
  }







  _CSIResult _parseCSI(
    String text,
    int start,
  ) {


    String number='';


    List<int> args=[];


    int i=start;



    while(
      i < text.length
    ) {


      final c=text[i];



      if(
        c.codeUnitAt(0)>=0x40 &&
        c.codeUnitAt(0)<=0x7E
      ) {


        if(number.isNotEmpty){

          args.add(
            int.parse(number),
          );
        }



        return _CSIResult(
          c,
          args,
          i+1,
        );
      }



      if(c==';') {


        args.add(
          number.isEmpty
          ?0
          :int.parse(number),
        );


        number='';


      } else {


        number += c;
      }



      i++;
    }



    return _CSIResult(
      '',
      [],
      i,
    );
  }
}




class _CSIResult {

 final String command;

 final List<int> args;

 final int index;


 _CSIResult(
   this.command,
   this.args,
   this.index,
 );
}
