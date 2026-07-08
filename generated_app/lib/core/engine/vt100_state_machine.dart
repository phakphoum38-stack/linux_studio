import 'screen_buffer.dart';
import 'ansi_csi_parser.dart';



class VT100StateMachine {


  final ScreenBuffer buffer;


  bool cursorVisible=true;



  VT100StateMachine([
    ScreenBuffer? buffer,
  ]) : buffer = buffer ?? ScreenBuffer();




  int get cursorRow =>
      buffer.cursor.row;


  set cursorRow(int value){

    buffer.cursor.row =
        value.clamp(
          0,
          buffer.rows-1,
        );

  }


  int get cursorCol =>
      buffer.cursor.col;


  set cursorCol(int value){

    buffer.cursor.col =
        value.clamp(
          0,
          buffer.cols-1,
        );

  }


  int get fg =>
      buffer.currentForeground;


  int get bg =>
      buffer.currentBackground;


  void applyCommand(
    String cmd,
    List<int> args,
  ){

    execute(
      cmd,
      args,
    );

  }


  void process(
    String cmd,
    List<int> args,
    ScreenBuffer target,
  ){

    execute(
      cmd,
      args,
    );

  }






  void handle(
    AnsiEvent event,
  ){


    if(event is TextEvent){

      buffer.writeText(
        event.text,
      );


    }



    if(event is CsiEvent){

      execute(
        event.command,
        event.args,
      );

    }


  }









  void execute(
    String cmd,
    List<int> args,
  ){


    switch(cmd){



      // Cursor Up
      case 'A':

        buffer.cursor.row =
            (buffer.cursor.row -
            _value(args))
            .clamp(
              0,
              buffer.rows-1,
            );

        break;





      // Cursor Down
      case 'B':

        buffer.cursor.row =
            (buffer.cursor.row +
            _value(args))
            .clamp(
              0,
              buffer.rows-1,
            );

        break;





      // Cursor Forward
      case 'C':

        buffer.cursor.col =
            (buffer.cursor.col +
            _value(args))
            .clamp(
              0,
              buffer.cols-1,
            );

        break;





      // Cursor Back
      case 'D':

        buffer.cursor.col =
            (buffer.cursor.col -
            _value(args))
            .clamp(
              0,
              buffer.cols-1,
            );

        break;







      // Cursor Position
      case 'H':

      case 'f':

        buffer.cursor.row =
            ((args.isNotEmpty
                ? args[0]
                : 1)-1)
            .clamp(
              0,
              buffer.rows-1,
            );


        buffer.cursor.col =
            ((args.length>1
                ? args[1]
                : 1)-1)
            .clamp(
              0,
              buffer.cols-1,
            );


        break;







      // Clear screen
      case 'J':

        if(_value(args)==2){

          buffer.clear();

        }

        break;







      // Clear line
      case 'K':

        buffer.clearLine(
          buffer.cursor.row,
        );

        break;







      // SGR Color
      case 'm':

        _style(
          args,
        );

        break;




      // Cursor visibility
      case 'h':

        if(args.contains(25)){

          cursorVisible=true;

        }

        break;




      case 'l':

        if(args.contains(25)){

          cursorVisible=false;

        }

        break;


    }

  }








  int _value(
    List<int> args,
  ){

    if(args.isEmpty ||
       args[0]==0){

      return 1;

    }


    return args[0];

  }









  void _style(
    List<int> args,
  ){


    if(args.isEmpty){

      buffer.currentForeground=37;

      buffer.currentBackground=40;

      return;

    }





    for(final a in args){


      if(a>=30 && a<=37){

        buffer.currentForeground=a;

      }


      if(a>=40 && a<=47){

        buffer.currentBackground=a;

      }



      if(a==1){

        buffer.bold=true;

      }



      if(a==4){

        buffer.underline=true;

      }



      if(a==7){

        buffer.inverse=true;

      }



    }


  }


}
