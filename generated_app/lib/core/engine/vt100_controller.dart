import 'screen_buffer.dart';



class VT100Controller {


  bool cursorVisible = true;



  bool bold = false;



  bool underline = false;



  bool inverse = false;









  void execute(

    String command,

    List<int> args,

    ScreenBuffer buffer,

  )

  {


    switch(command)

    {



      // Cursor Up
      case 'A':

        buffer.cursor.row =

            (buffer.cursor.row -
             _value(args))

            .clamp(

              0,

              buffer.rows - 1,

            );

        break;







      // Cursor Down
      case 'B':

        buffer.cursor.row =

            (buffer.cursor.row +
             _value(args))

            .clamp(

              0,

              buffer.rows - 1,

            );

        break;







      // Cursor Right
      case 'C':

        buffer.cursor.col =

            (buffer.cursor.col +
             _value(args))

            .clamp(

              0,

              buffer.cols - 1,

            );

        break;







      // Cursor Left
      case 'D':

        buffer.cursor.col =

            (buffer.cursor.col -
             _value(args))

            .clamp(

              0,

              buffer.cols - 1,

            );

        break;







      // Cursor position
      case 'H':

      case 'f':

        final row =

            args.isNotEmpty
                ? args[0]
                : 1;



        final col =

            args.length > 1
                ? args[1]
                : 1;



        buffer.cursor.row =

            (row - 1)

            .clamp(

              0,

              buffer.rows - 1,

            );



        buffer.cursor.col =

            (col - 1)

            .clamp(

              0,

              buffer.cols - 1,

            );


        break;








      // Clear screen
      case 'J':

        if(_value(args)==2)

        {

          buffer.clear();

        }

        break;








      // Clear line
      case 'K':

        buffer.clearLine(

          buffer.cursor.row,

        );

        break;








      // Style
      case 'm':

        _applyStyle(

          args,

          buffer,

        );

        break;








      // Cursor show

      case 'h':

        if(args.contains(25))

        {

          cursorVisible = true;

        }

        break;








      // Cursor hide

      case 'l':

        if(args.contains(25))

        {

          cursorVisible = false;

        }

        break;



    }


  }









  int _value(

    List<int> args,

  )

  {


    if(args.isEmpty ||
       args[0]==0)

    {

      return 1;

    }



    return args[0];


  }









  void _applyStyle(

    List<int> args,

    ScreenBuffer buffer,

  )

  {


    if(args.isEmpty)

    {

      buffer.currentForeground = 37;

      buffer.currentBackground = 40;

      return;

    }







    for(final value in args)

    {



      if(value >=30 &&
         value <=37)

      {

        buffer.currentForeground =
            value;

      }







      if(value >=40 &&
         value <=47)

      {

        buffer.currentBackground =
            value;

      }







      if(value==1)

      {

        bold = true;

      }







      if(value==4)

      {

        underline = true;

      }







      if(value==7)

      {

        inverse = true;

      }


    }


  }


}
