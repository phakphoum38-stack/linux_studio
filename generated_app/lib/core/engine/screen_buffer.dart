import 'dart:async';

import 'package:flutter/foundation.dart';

import 'terminal_cell.dart';





class TerminalCursor {



  int row;

  int col;



  bool visible = true;



  Timer? _timer;







  TerminalCursor({

    this.row = 0,

    this.col = 0,

  });









  void startBlink(

    VoidCallback update,

  )

  {


    stopBlink();



    _timer = Timer.periodic(

      const Duration(

        milliseconds: 500,

      ),

      (_) {

        visible = !visible;

        update();

      },

    );


  }









  void stopBlink()

  {

    _timer?.cancel();

    _timer = null;

  }



}









class ScreenBuffer {



  int rows;

  int cols;







  late List<List<TerminalCell>> _buffer;







  final TerminalCursor cursor =

      TerminalCursor();







  int currentForeground = 37;



  int currentBackground = 40;







  bool bold = false;



  bool italic = false;



  bool underline = false;



  bool inverse = false;









  ScreenBuffer({

    this.rows = 24,

    this.cols = 80,

  })

  {

    _createBuffer();

  }









  List<List<TerminalCell>> get buffer =>

      _buffer;









  void _createBuffer()

  {


    _buffer = List.generate(

      rows,

      (_) => List.generate(

        cols,

        (_) => TerminalCell(),

      ),

    );


  }









  void resize(

    int newRows,

    int newCols,

  )

  {


    rows = newRows;

    cols = newCols;



    _createBuffer();



    cursor.row = 0;

    cursor.col = 0;


  }









  void writeText(

    String text,

  )

  {


    for(final char in text.split(''))

    {


      if(char == '\n')

      {

        cursor.row++;

        cursor.col = 0;


        if(cursor.row >= rows)

        {

          scroll();

        }


        continue;

      }







      if(char == '\r')

      {

        cursor.col = 0;

        continue;

      }







      writeChar(char);


    }


  }









  void writeChar(

    String char,

  )

  {


    if(cursor.row >= rows)

    {

      scroll();

    }







    if(cursor.col >= cols)

    {

      cursor.col = 0;

      cursor.row++;


      if(cursor.row >= rows)

      {

        scroll();

      }

    }







    final cell =

        _buffer[cursor.row][cursor.col];







    cell.char = char;



    cell.foreground = currentForeground;



    cell.background = currentBackground;



    cell.bold = bold;



    cell.italic = italic;



    cell.underline = underline;



    cell.inverse = inverse;







    cursor.col++;


  }









  void scroll()

  {


    if(_buffer.isEmpty)

    {

      return;

    }







    _buffer.removeAt(0);







    _buffer.add(

      List.generate(

        cols,

        (_) => TerminalCell(),

      ),

    );







    cursor.row = rows - 1;


  }









  void clear()

  {


    _createBuffer();



    cursor.row = 0;

    cursor.col = 0;



    resetStyle();


  }









  void clearLine(

    int row,

  )

  {


    if(row < 0 ||

       row >= rows)

    {

      return;

    }







    for(int col = 0;

        col < cols;

        col++)

    {

      _buffer[row][col] =

          TerminalCell();

    }


  }









  void eraseToEndOfLine()

  {


    for(int col = cursor.col;

        col < cols;

        col++)

    {

      _buffer[cursor.row][col] =

          TerminalCell();

    }


  }









  void eraseToBeginningOfLine()

  {


    for(int col = 0;

        col <= cursor.col;

        col++)

    {

      _buffer[cursor.row][col] =

          TerminalCell();

    }


  }









  void eraseToEndOfScreen()

  {


    for(int r = cursor.row;

        r < rows;

        r++)

    {


      int start =

          r == cursor.row

          ? cursor.col

          : 0;



      for(int c = start;

          c < cols;

          c++)

      {

        _buffer[r][c] =

            TerminalCell();

      }

    }


  }









  void eraseToBeginningOfScreen()

  {


    for(int r = 0;

        r <= cursor.row;

        r++)

    {


      int end =

          r == cursor.row

          ? cursor.col

          : cols;



      for(int c = 0;

          c <= end && c < cols;

          c++)

      {

        _buffer[r][c] =

            TerminalCell();

      }

    }


  }









  void resetStyle()

  {


    currentForeground = 37;

    currentBackground = 40;



    bold = false;

    italic = false;

    underline = false;

    inverse = false;


  }









  List<String> get lines

  {


    return _buffer.map(

      (row)

      => row.map(

        (cell)

        => cell.char,

      )

      .join(),

    )

    .toList();


  }









  void dispose()

  {

    cursor.stopBlink();

  }



}