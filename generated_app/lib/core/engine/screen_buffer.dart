import 'cursor_position.dart';
import 'terminal_cell.dart';


class ScreenBuffer {

  final int rows;
  final int cols;


  late List<List<TerminalCell>> buffer;


  final CursorPosition cursor =
      CursorPosition();



  int currentForeground = 37;
  int currentBackground = 40;


  bool bold = false;
  bool italic = false;
  bool underline = false;
  bool inverse = false;



  ScreenBuffer({
    this.rows = 24,
    this.cols = 80,
  }) {
    _initialize();
  }





  void _initialize(){

    buffer =
        List.generate(
          rows,
          (_) => List.generate(
            cols,
            (_) => TerminalCell(),
          ),
        );

  }





  // Compatibility

  int get width => cols;

  int get height => rows;


  int get currentFg =>
      currentForeground;


  set currentFg(int value){

    currentForeground = value;

  }



  int get currentBg =>
      currentBackground;


  set currentBg(int value){

    currentBackground = value;

  }







  bool inBounds(
    int row,
    int col,
  ){

    return row >=0 &&
        row < rows &&
        col >=0 &&
        col < cols;

  }







  TerminalCell cellAt(
    int row,
    int col,
  ){

    return buffer[row][col];

  }







  TerminalCell cell(
    int row,
    int col,
  ) =>
      cellAt(row,col);







  void moveCursor(
    int row,
    int col,
  ){

    cursor.row =
        row.clamp(
          0,
          rows-1,
        );


    cursor.col =
        col.clamp(
          0,
          cols-1,
        );

  }







  void setAttributes(
    int fg,
    int bg,
    bool bold,
    bool underline,
    bool inverse,
  ){

    currentForeground = fg;

    currentBackground = bg;

    this.bold = bold;

    this.underline = underline;

    this.inverse = inverse;

  }







  void write(
    int row,
    int col,
    String ch,
  ){

    if(!inBounds(row,col))
      return;


    buffer[row][col].char = ch;

  }







  void setColor(
    int row,
    int col,
    int fg,
    int bg,
  ){

    if(!inBounds(row,col))
      return;


    buffer[row][col].foreground = fg;

    buffer[row][col].background = bg;

  }







  void clear(){

    for(int r=0;r<rows;r++){

      for(int c=0;c<cols;c++){

        buffer[r][c].reset();

      }

    }


    cursor.reset();

  }







  void clearLine(
    int row,
  ){

    if(row < 0 || row >= rows)
      return;


    for(
      int c=0;
      c<cols;
      c++
    ){

      buffer[row][c] =
          TerminalCell();

    }

  }







  void scrollUp(
    [
      int count = 1
    ],
  ){

    for(
      int i=0;
      i<count;
      i++
    ){

      buffer.removeAt(0);


      buffer.add(
        List.generate(
          cols,
          (_) => TerminalCell(),
        ),
      );

    }

  }







  void scrollDown(
    [
      int count = 1
    ],
  ){

    for(
      int i=0;
      i<count;
      i++
    ){

      buffer.removeLast();


      buffer.insert(
        0,
        List.generate(
          cols,
          (_) => TerminalCell(),
        ),
      );

    }

  }







  void putChar(
    String ch,
  ){

    if(!inBounds(
      cursor.row,
      cursor.col,
    )) return;



    buffer[cursor.row][cursor.col] =
        TerminalCell(

          char: ch,

          foreground:
              currentForeground,

          background:
              currentBackground,

          bold:bold,

          italic:italic,

          underline:underline,

          inverse:inverse,

        );



    cursor.col++;



    if(cursor.col >= cols){

      cursor.col=0;

      cursor.row++;


      if(cursor.row >= rows){

        scrollUp();

        cursor.row =
            rows-1;

      }

    }

  }







  void writeText(
    String text,
  ){

    for(final rune in text.runes){

      final ch =
          String.fromCharCode(rune);



      switch(ch){


        case '\n':

          cursor.row++;

          cursor.col=0;


          if(cursor.row >= rows){

            scrollUp();

            cursor.row =
                rows-1;

          }


          break;



        case '\r':

          cursor.col=0;

          break;



        case '\b':

          if(cursor.col>0)
            cursor.col--;

          break;



        default:

          putChar(ch);

      }

    }

  }







  void insertChar(
    int row,
    int col,
  ){

    if(!inBounds(row,col))
      return;


    for(
      int c=cols-1;
      c>col;
      c--
    ){

      buffer[row][c] =
          buffer[row][c-1].copy();

    }


    buffer[row][col] =
        TerminalCell();

  }







  void deleteChar(
    int row,
    int col,
  ){

    if(!inBounds(row,col))
      return;


    for(
      int c=col;
      c<cols-1;
      c++
    ){

      buffer[row][c] =
          buffer[row][c+1].copy();

    }


    buffer[row][cols-1] =
        TerminalCell();

  }







  void writeChar(String ch)
      => putChar(ch);


  void writeString(String text)
      => writeText(text);


}
