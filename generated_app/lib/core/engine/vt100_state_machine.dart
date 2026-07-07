import 'screen_buffer.dart';
import 'terminal_event.dart';


class VT100StateMachine {


  int row = 0;
  int col = 0;


  int foreground = 37;
  int background = 40;


  bool bold = false;
  bool underline = false;
  bool inverse = false;



  bool cursorVisible = true;



  void apply(
    TerminalEvent event,
    ScreenBuffer buffer,
  ) {


    switch(event.type) {


      case TerminalEventType.text:

        final e = event as TextEvent;

        buffer.moveCursor(
          row,
          col,
        );

        buffer.setAttributes(
          foreground,
          background,
          bold,
          underline,
          inverse,
        );

        buffer.writeText(
          e.text,
        );


        _syncCursor(buffer);

        break;





      case TerminalEventType.cursorMove:


        final e =
            event as CursorMoveEvent;


        row += e.row;
        col += e.col;


        _clamp(
          buffer,
        );


        break;






      case TerminalEventType.cursorPosition:


        final e =
            event as CursorPositionEvent;


        row=e.row;
        col=e.col;


        _clamp(
          buffer,
        );


        break;






      case TerminalEventType.setColor:


        final e =
            event as SetColorEvent;


        foreground =
            e.foreground;


        background =
            e.background;


        break;






      case TerminalEventType.eraseDisplay:


        final e =
            event as EraseDisplayEvent;


        _eraseDisplay(
          e.mode,
          buffer,
        );


        break;






      case TerminalEventType.eraseLine:


        final e =
            event as EraseLineEvent;


        _eraseLine(
          e.mode,
          buffer,
        );


        break;






      case TerminalEventType.scroll:


        final e =
            event as ScrollEvent;


        buffer.scrollUp(
          e.amount,
        );


        break;






      case TerminalEventType.bell:

        break;



      case TerminalEventType.setAttribute:


        final e =
            event as AttributeEvent;


        bold =
            e.bold;

        underline =
            e.underline;

        inverse =
            e.inverse;


        break;




      case TerminalEventType.resize:

        break;

    }

  }









  void _syncCursor(
    ScreenBuffer buffer,
  ){

    row =
        buffer.cursor.row;


    col =
        buffer.cursor.col;

  }









  void _clamp(
    ScreenBuffer buffer,
  ){

    if(row < 0)
      row = 0;


    if(col < 0)
      col = 0;



    if(row >= buffer.rows)
      row = buffer.rows-1;


    if(col >= buffer.cols)
      col = buffer.cols-1;

  }









  void _eraseDisplay(
    int mode,
    ScreenBuffer buffer,
  ){

    switch(mode){


      case 2:

        buffer.clear();

        break;


      default:

        break;

    }

  }









  void _eraseLine(
    int mode,
    ScreenBuffer buffer,
  ){

    buffer.clearLine(
      row,
    );

  }



  void reset(){

    row=0;
    col=0;

    foreground=37;
    background=40;

    bold=false;
    underline=false;
    inverse=false;

  }

}
