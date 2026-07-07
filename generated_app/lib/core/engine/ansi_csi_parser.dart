import 'terminal_event.dart';



class AnsiCsiParser {


  final StringBuffer _text =
      StringBuffer();



  List<TerminalEvent> parse(
    String input,
  ) {

    final List<TerminalEvent> events =
        [];



    int i = 0;



    while(
      i < input.length
    ) {


      final char =
          input[i];



      // ESC
      if(char == '\x1B') {


        if(_text.isNotEmpty){

          events.add(
            TextEvent(
              _text.toString(),
            ),
          );

          _text.clear();

        }



        final result =
            _parseEscape(
              input,
              i,
            );



        events.addAll(
          result.events,
        );


        i =
            result.index;


        continue;

      }





      // Bell

      if(char == '\x07'){


        events.add(
          const BellEvent(),
        );


        i++;

        continue;
      }




      _text.write(char);


      i++;

    }



    if(_text.isNotEmpty){


      events.add(
        TextEvent(
          _text.toString(),
        ),
      );


      _text.clear();

    }



    return events;
  }







  _ParseResult _parseEscape(
    String text,
    int index,
  ){


    if(
      index + 1 >= text.length
    ){

      return _ParseResult(
        [],
        index + 1,
      );

    }



    // CSI

    if(
      text[index + 1] == '['
    ){

      return _parseCSI(
        text,
        index + 2,
      );

    }





    // ESC s save cursor

    if(
      text[index+1]=='7'
    ){

      return _ParseResult(
        [
          const CursorMoveEvent(
            row: -1,
            col: -1,
          )
        ],
        index+2,
      );
    }





    // ESC u restore cursor

    if(
      text[index+1]=='8'
    ){

      return _ParseResult(
        [
          const CursorMoveEvent(
            row: -2,
            col: -2,
          )
        ],
        index+2,
      );
    }



    return _ParseResult(
      [],
      index+2,
    );

  }









  _ParseResult _parseCSI(
    String text,
    int start,
  ){


    List<int> args=[];


    String number='';


    int i=start;



    while(
      i < text.length
    ){


      final c=text[i];



      if(
        c.codeUnitAt(0)>=0x40 &&
        c.codeUnitAt(0)<=0x7E
      ){



        if(number.isNotEmpty){

          args.add(
            int.parse(number),
          );

        }



        return _createEvent(
          c,
          args,
          i+1,
        );

      }




      if(c==';'){


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



    return _ParseResult(
      [],
      i,
    );

  }









  _ParseResult _createEvent(
    String command,
    List<int> args,
    int index,
  ){



    switch(command){



      // Cursor Up

      case 'A':

        return _ParseResult(
          [
            CursorMoveEvent(
              row: -(args.isEmpty?1:args[0]),
              col: 0,
            )
          ],
          index,
        );





      // Cursor Down

      case 'B':

        return _ParseResult(
          [
            CursorMoveEvent(
              row: args.isEmpty?1:args[0],
              col:0,
            )
          ],
          index,
        );





      // Cursor Forward

      case 'C':

        return _ParseResult(
          [
            CursorMoveEvent(
              row:0,
              col:args.isEmpty?1:args[0],
            )
          ],
          index,
        );





      // Cursor Back

      case 'D':

        return _ParseResult(
          [
            CursorMoveEvent(
              row:0,
              col:-(args.isEmpty?1:args[0]),
            )
          ],
          index,
        );







      // Cursor position

      case 'H':
      case 'f':

        return _ParseResult(
          [
            CursorPositionEvent(
              row:
                (args.isNotEmpty
                ?args[0]
                :1)-1,

              col:
                (args.length>1
                ?args[1]
                :1)-1,
            )
          ],
          index,
        );







      // Clear Display

      case 'J':

        return _ParseResult(
          [
            EraseDisplayEvent(
              args.isEmpty?0:args[0],
            )
          ],
          index,
        );








      // Clear Line

      case 'K':

        return _ParseResult(
          [
            EraseLineEvent(
              args.isEmpty?0:args[0],
            )
          ],
          index,
        );







      // Color

      case 'm':

        return _colorEvent(
          args,
          index,
        );






      // Scroll Up

      case 'S':

        return _ParseResult(
          [
            ScrollEvent(
              args.isEmpty?1:args[0],
            )
          ],
          index,
        );



      default:

        return _ParseResult(
          [],
          index,
        );

    }

  }








  _ParseResult _colorEvent(
    List<int> args,
    int index,
  ){


    int fg=37;

    int bg=40;



    for(final a in args){


      if(a>=30 && a<=37){

        fg=a;

      }


      if(a>=40 && a<=47){

        bg=a;

      }

    }



    return _ParseResult(
      [
        SetColorEvent(
          foreground:fg,
          background:bg,
        )
      ],
      index,
    );

  }

}









class _ParseResult {

  final List<TerminalEvent> events;

  final int index;



  _ParseResult(
    this.events,
    this.index,
  );

}
