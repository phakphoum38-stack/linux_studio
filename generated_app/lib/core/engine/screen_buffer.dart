class TerminalCursor {


  int row;


  int col;



  TerminalCursor({

    this.row = 0,

    this.col = 0,

  });


}









class ScreenBuffer {



  ScreenBuffer({

    this.rows = 24,

    this.cols = 80,

  })

  {


    _createBuffer();


  }






  int rows;


  int cols;






  late List<List<String>> _buffer;





  final TerminalCursor cursor =

      TerminalCursor();





  int currentForeground = 37;


  int currentBackground = 40;



  bool bold = false;


  bool underline = false;


  bool inverse = false;









  void _createBuffer()

  {


    _buffer =

        List.generate(

          rows,

          (_) =>

              List.generate(

                cols,

                (_) => ' ',

              ),

        );


  }









  List<String> get lines =>


      _buffer

          .map(

            (line)

            => line.join(),

          )

          .toList();









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



        _scroll();


        continue;


      }







      if(char == '\r')

      {


        cursor.col = 0;


        continue;


      }







      if(cursor.row >= rows)

      {


        _scroll();


      }







      if(cursor.col >= cols)

      {


        cursor.col = 0;


        cursor.row++;


        _scroll();


      }








      _buffer[cursor.row][cursor.col] =

          char;



      cursor.col++;


    }


  }









  void clear()

  {


    _createBuffer();



    cursor.row = 0;


    cursor.col = 0;


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





    for(

      int i = 0;

      i < cols;

      i++

    )

    {


      _buffer[row][i] = ' ';


    }


  }









  void _scroll()

  {


    if(cursor.row < rows)

    {

      return;

    }





    _buffer.removeAt(0);



    _buffer.add(

      List.generate(

        cols,

        (_) => ' ',

      ),

    );



    cursor.row = rows - 1;


  }









  String getLine(

    int row,

  )

  {


    if(row < 0 ||
       row >= rows)

    {

      return '';

    }



    return _buffer[row].join();


  }



}
