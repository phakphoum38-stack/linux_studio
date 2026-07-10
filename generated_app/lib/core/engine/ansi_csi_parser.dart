abstract class AnsiEvent {}



class TextEvent extends AnsiEvent {


  final String text;


  TextEvent(

    this.text,

  );


}







class CsiEvent extends AnsiEvent {


  final String command;


  final List<int> args;



  CsiEvent(

    this.command,

    this.args,

  );


}









class AnsiCsiParser {


  final StringBuffer _text =

      StringBuffer();



  bool _escape = false;



  bool _csi = false;



  String _buffer = '';









  List<AnsiEvent> parse(

    String input,

  )

  {


    final List<AnsiEvent> events = [];






    for(final rune in input.runes)

    {


      final char =

          String.fromCharCode(

            rune,

          );







      if(!_escape)

      {


        if(char == '\x1B')

        {


          _flushText(events);



          _escape = true;


        }

        else

        {


          _text.write(

            char,

          );


        }


        continue;

      }








      if(_escape && !_csi)

      {


        if(char == '[')

        {


          _csi = true;

          _buffer = '';

        }

        else

        {


          _escape = false;


        }


        continue;


      }








      if(_csi)

      {



        if(char.codeUnitAt(0)>=

              0x40)

        {



          final args =

              _parseArgs(

                _buffer,

              );





          events.add(

            CsiEvent(

              char,

              args,

            ),

          );





          _escape = false;

          _csi = false;

          _buffer='';



        }

        else

        {


          _buffer += char;


        }



      }



    }






    _flushText(events);




    return events;


  }









  List<int> _parseArgs(

    String value,

  )

  {


    if(value.isEmpty)

    {

      return [];

    }






    return value

        .split(';')

        .map(

          (e)

          => int.tryParse(e)

              ?? 0,

        )

        .toList();


  }









  void _flushText(

    List<AnsiEvent> events,

  )

  {


    if(_text.isNotEmpty)

    {


      events.add(

        TextEvent(

          _text.toString(),

        ),

      );


      _text.clear();


    }


  }



}
