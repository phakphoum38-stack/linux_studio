import 'ansi_csi_parser.dart';
import 'screen_buffer.dart';
import 'terminal_cell.dart';





class VT100StateMachine {



  final ScreenBuffer buffer;



  bool cursorVisible = true;



  int _savedRow = 0;

  int _savedCol = 0;









  VT100StateMachine([

    ScreenBuffer? buffer,

  ])

      :

        buffer =

            buffer ??

            ScreenBuffer();









  int get cursorRow =>

      buffer.cursor.row;







  int get cursorCol =>

      buffer.cursor.col;









  set cursorRow(int value)

  {

    buffer.cursor.row =

        value.clamp(

          0,

          buffer.rows - 1,

        );

  }









  set cursorCol(int value)

  {

    buffer.cursor.col =

        value.clamp(

          0,

          buffer.cols - 1,

        );

  }









  void handle(

    AnsiEvent event,

  )

  {


    if(event is TextEvent)

    {

      buffer.writeText(

        event.text,

      );



      return;

    }







    if(event is CsiEvent)

    {

      execute(

        event.command,

        event.args,

      );

    }


  }









  void execute(

    String command,

    List<int> args,

  )

  {


    switch(command)

    {


      case 'A':

        cursorUp(args);

        break;



      case 'B':

        cursorDown(args);

        break;



      case 'C':

        cursorForward(args);

        break;



      case 'D':

        cursorBack(args);

        break;



      case 'H':

      case 'f':

        cursorPosition(args);

        break;



      case 'J':

        eraseDisplay(args);

        break;



      case 'K':

        eraseLine(args);

        break;



      case 'm':

        graphicsMode(args);

        break;



      case 's':

        saveCursor();

        break;



      case 'u':

        restoreCursor();

        break;



      case 'h':

        if(args.contains(25))

        {

          setCursorVisible(true);

        }

        break;



      case 'l':

        if(args.contains(25))

        {

          setCursorVisible(false);

        }

        break;


    }


  }









  int value(

    List<int> args,

  )

  {


    if(args.isEmpty ||

       args.first == 0)

    {

      return 1;

    }



    return args.first;


  }









  void cursorUp(

    List<int> args,

  )

  {

    cursorRow -= value(args);

  }









  void cursorDown(

    List<int> args,

  )

  {

    cursorRow += value(args);

  }









  void cursorForward(

    List<int> args,

  )

  {

    cursorCol += value(args);

  }









  void cursorBack(

    List<int> args,

  )

  {

    cursorCol -= value(args);

  }









  void cursorPosition(

    List<int> args,

  )

  {


    cursorRow =

        (args.isNotEmpty

            ? args[0]

            : 1)

        - 1;





    cursorCol =

        (args.length > 1

            ? args[1]

            : 1)

        - 1;


  }









  void eraseDisplay(

    List<int> args,

  )

  {


    final mode =

        args.isEmpty

        ? 0

        : args.first;





    if(mode == 2)

    {

      buffer.clear();

      return;

    }







    for(

      int r = 0;

      r < buffer.rows;

      r++

    )

    {

      for(

        int c = 0;

        c < buffer.cols;

        c++

      )

      {

        buffer.buffer[r][c].clear();

      }

    }


  }









  void eraseLine(

    List<int> args,

  )

  {


    final row = cursorRow;



    buffer.clearLine(

      row,

    );


  }









  void graphicsMode(

    List<int> args,

  )

  {


    if(args.isEmpty)

    {

      resetStyle();

      return;

    }







    for(final code in args)

    {


      switch(code)

      {


        case 0:

          resetStyle();

          break;



        case 1:

          buffer.bold = true;

          break;



        case 3:

          buffer.italic = true;

          break;



        case 4:

          buffer.underline = true;

          break;



        case 22:

          buffer.bold = false;

          break;



        case 23:

          buffer.italic = false;

          break;



        case 24:

          buffer.underline = false;

          break;



        default:


          if(code >= 30 && code <= 37)

          {

            buffer.currentForeground = code;

          }





          if(code >= 40 && code <= 47)

          {

            buffer.currentBackground = code;

          }


      }


    }


  }









  void resetStyle()

  {

    buffer.currentForeground = 37;

    buffer.currentBackground = 40;


    buffer.bold = false;

    buffer.underline = false;

    buffer.italic = false;

    buffer.inverse = false;

  }









  void saveCursor()

  {

    _savedRow = cursorRow;

    _savedCol = cursorCol;

  }









  void restoreCursor()

  {

    cursorRow = _savedRow;

    cursorCol = _savedCol;

  }









  void setCursorVisible(

    bool value,

  )

  {

    cursorVisible = value;

    buffer.cursor.visible = value;

  }









  void scrollUp(

    int count,

  )

  {


    for(int i = 0; i < count; i++)

    {


      buffer.buffer.removeAt(0);


      buffer.buffer.add(

        List.generate(

          buffer.cols,

          (_) => TerminalCell(),

        ),

      );


    }


  }









  void scrollDown(

    int count,

  )

  {


    for(int i = 0; i < count; i++)

    {


      buffer.buffer.removeLast();


      buffer.buffer.insert(

        0,

        List.generate(

          buffer.cols,

          (_) => TerminalCell(),

        ),

      );


    }


  }









  void reset()

  {

    buffer.clear();


    cursorVisible = true;


    buffer.cursor.visible = true;



    _savedRow = 0;

    _savedCol = 0;



    resetStyle();

  }




  int get fg => buffer.currentForeground;

  int get bg => buffer.currentBackground;

  void process(
    String command,
    List<int> args,
    ScreenBuffer target,
  ) {
    execute(command, args);
  }

  void applyCommand(
    String command,
    List<int> args,
  ) {
    execute(command, args);
  }
}