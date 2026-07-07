import 'terminal_keyboard.dart';


class KeyboardPipeline {


  Function(String data)? onInput;



  void sendKey(
    String key,
  ){


    final data =
        TerminalKeyboard.handle(
          key,
        );


    onInput?.call(
      data,
    );


  }





  void sendText(
    String text,
  ){

    onInput?.call(
      text,
    );

  }



}
