enum TerminalEventType {
  print,
  cursorMove,
  erase,
  color,
  bell,
}


class TerminalEvent {

  final TerminalEventType type;

  final String? data;

  final List<int>? args;


  TerminalEvent({
    required this.type,
    this.data,
    this.args,
  });

}
