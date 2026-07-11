class TerminalCell {


  String char;


  int foreground;


  int background;


  bool bold;


  bool underline;


  bool italic;


  bool inverse;





  TerminalCell({

    this.char = ' ',

    this.foreground = 37,

    this.background = 40,

    this.bold = false,

    this.underline = false,

    this.italic = false,

    this.inverse = false,

  });








  void clear()

  {


    char = ' ';


    foreground = 37;


    background = 40;



    bold = false;


    underline = false;


    italic = false;


    inverse = false;


  }







  TerminalCell copy()

  {


    return TerminalCell(

      char: char,

      foreground: foreground,

      background: background,

      bold: bold,

      underline: underline,

      italic: italic,

      inverse: inverse,

    );


  }



}