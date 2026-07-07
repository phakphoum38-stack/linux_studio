import 'terminal_mouse.dart';


class MousePipeline {


  Function(TerminalMouseEvent)?
      onMouse;



  void press(
    int row,
    int col,
  ){

    onMouse?.call(

      TerminalMouseEvent(

        row: row,

        col: col,

        button:
          MouseButton.left,

        action:
          MouseAction.press,

      ),

    );

  }






  void move(
    int row,
    int col,
  ){

    onMouse?.call(

      TerminalMouseEvent(

        row: row,

        col: col,

        button:
          MouseButton.left,

        action:
          MouseAction.move,

      ),

    );

  }







  void release(
    int row,
    int col,
  ){

    onMouse?.call(

      TerminalMouseEvent(

        row: row,

        col: col,

        button:
          MouseButton.left,

        action:
          MouseAction.release,

      ),

    );

  }


}
