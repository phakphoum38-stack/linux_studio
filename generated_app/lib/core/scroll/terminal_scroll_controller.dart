import 'scrollback_buffer.dart';


class TerminalScrollController {



  final ScrollbackBuffer buffer;



  int offset = 0;



  TerminalScrollController(
    this.buffer,
  );





  bool get atBottom =>
      offset == 0;






  void scrollUp(int amount){

    offset += amount;


    if(offset > buffer.length){

      offset = buffer.length;

    }

  }







  void scrollDown(int amount){

    offset -= amount;


    if(offset < 0){

      offset = 0;

    }

  }







  void pageUp(){

    scrollUp(20);

  }







  void pageDown(){

    scrollDown(20);

  }







  void bottom(){

    offset = 0;

  }






  List<String> visible(
    int rows,
  ){


    final end =
        buffer.length - offset;


    final start =
        end - rows;



    final safeStart =
        start < 0
            ? 0
            : start;



    return buffer.lines
        .sublist(
          safeStart,
          end,
        );

  }

}
