class AnsiEvent {}

class TextEvent extends AnsiEvent {
  final String text;

  TextEvent(this.text);
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


  String _buffer = '';



  List<AnsiEvent> parse(
    String input,
  ){

    final events = <AnsiEvent>[];


    _buffer += input;



    while(_buffer.isNotEmpty){


      final esc =
          _buffer.indexOf('\x1b');



      if(esc == -1){

        events.add(
          TextEvent(
            _buffer,
          ),
        );

        _buffer='';

        break;

      }




      if(esc > 0){

        events.add(

          TextEvent(
            _buffer.substring(
              0,
              esc,
            ),
          ),

        );


        _buffer =
            _buffer.substring(
              esc,
            );

      }





      if(
        !_buffer.startsWith(
          '\x1b['
        )
      ){

        _buffer =
            _buffer.substring(1);

        continue;

      }






      final match =
          RegExp(
            r'^\x1b\[([0-9;?]*)([A-Za-z])'
          )
          .firstMatch(
            _buffer,
          );



      if(match == null){

        break;

      }






      final rawArgs =
          match.group(1)!;


      final command =
          match.group(2)!;



      final args =
          rawArgs.isEmpty

          ? <int>[]

          :

          rawArgs
          .replaceAll(
            '?',
            '',
          )
          .split(';')
          .map(
            (e)=>
              int.tryParse(e) ?? 0,
          )
          .toList();





      events.add(

        CsiEvent(
          command,
          args,
        ),

      );




      _buffer =
          _buffer.substring(
            match.end,
          );

    }


    return events;

  }

}
