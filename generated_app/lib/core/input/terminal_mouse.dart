enum MouseButton {

  left,

  middle,

  right,

}



enum MouseAction {

  press,

  release,

  move,

}



class TerminalMouseEvent {


  final int row;

  final int col;


  final MouseButton button;


  final MouseAction action;



  const TerminalMouseEvent({

    required this.row,

    required this.col,

    required this.button,

    required this.action,

  });


}
