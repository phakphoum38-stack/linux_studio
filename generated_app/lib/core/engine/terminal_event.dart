enum TerminalEventType {
  text,
  cursorMove,
  cursorPosition,
  eraseDisplay,
  eraseLine,
  setColor,
  setAttribute,
  scroll,
  bell,
  resize,
}



abstract class TerminalEvent {

  final TerminalEventType type;


  const TerminalEvent(
    this.type,
  );

}



// Text output
class TextEvent extends TerminalEvent {

  final String text;


  const TextEvent(
    this.text,
  ) : super(
    TerminalEventType.text,
  );

}




// Cursor movement
class CursorMoveEvent extends TerminalEvent {

  final int row;
  final int col;


  const CursorMoveEvent({
    required this.row,
    required this.col,
  }) : super(
    TerminalEventType.cursorMove,
  );

}




// Cursor absolute position
class CursorPositionEvent extends TerminalEvent {

  final int row;
  final int col;


  const CursorPositionEvent({
    required this.row,
    required this.col,
  }) : super(
    TerminalEventType.cursorPosition,
  );

}





// Clear screen
class EraseDisplayEvent extends TerminalEvent {

  final int mode;


  const EraseDisplayEvent(
    this.mode,
  ) : super(
    TerminalEventType.eraseDisplay,
  );

}





// Clear line
class EraseLineEvent extends TerminalEvent {

  final int mode;


  const EraseLineEvent(
    this.mode,
  ) : super(
    TerminalEventType.eraseLine,
  );

}





// ANSI Color
class SetColorEvent extends TerminalEvent {

  final int foreground;
  final int background;


  const SetColorEvent({
    required this.foreground,
    required this.background,
  }) : super(
    TerminalEventType.setColor,
  );

}





// Bold / underline / inverse
class AttributeEvent extends TerminalEvent {

  final bool bold;
  final bool underline;
  final bool inverse;


  const AttributeEvent({
    this.bold = false,
    this.underline = false,
    this.inverse = false,
  }) : super(
    TerminalEventType.setAttribute,
  );

}





// Scroll
class ScrollEvent extends TerminalEvent {

  final int amount;


  const ScrollEvent(
    this.amount,
  ) : super(
    TerminalEventType.scroll,
  );

}





// Terminal beep
class BellEvent extends TerminalEvent {

  const BellEvent()
      : super(
          TerminalEventType.bell,
        );

}





// Resize
class ResizeEvent extends TerminalEvent {

  final int cols;
  final int rows;


  const ResizeEvent({
    required this.cols,
    required this.rows,
  }) : super(
    TerminalEventType.resize,
  );

}
