import 'screen_buffer.dart';


class VT100StateMachine {

  int cursorRow = 0;

  int cursorCol = 0;


  int fg = 37;

  int bg = 40;



  void process(
    String command,
    List<int> args,
    ScreenBuffer buffer,
  ) {


    switch(command) {


      case 'A': // CUU

        cursorRow -=
            args.isEmpty ? 1 : args[0];

        break;



      case 'B': // CUD

        cursorRow +=
            args.isEmpty ? 1 : args[0];

        break;



      case 'C': // CUF

        cursorCol +=
            args.isEmpty ? 1 : args[0];

        break;



      case 'D': // CUB

        cursorCol -=
            args.isEmpty ? 1 : args[0];

        break;



      case 'H':
      case 'f':

        cursorRow =
            (args.isNotEmpty
                ? args[0]
                : 1) - 1;


        cursorCol =
            (args.length > 1
                ? args[1]
                : 1) - 1;

        break;



      case 'J':

        buffer.clear();

        break;



      case 'm':

        _setColor(args);

        break;
    }



    _clamp(
      buffer,
    );
  }




  void _setColor(
    List<int> args,
  ) {


    if(args.isEmpty) {

      fg = 37;

      bg = 40;

      return;
    }



    for(final a in args) {


      if(a >=30 &&
         a <=37) {

        fg = a;
      }



      if(a >=40 &&
         a <=47) {

        bg = a;
      }
    }
  }




  void _clamp(
    ScreenBuffer buffer,
  ) {

    cursorRow =
        cursorRow.clamp(
          0,
          buffer.rows-1,
        );


    cursorCol =
        cursorCol.clamp(
          0,
          buffer.cols-1,
        );
  }
}
