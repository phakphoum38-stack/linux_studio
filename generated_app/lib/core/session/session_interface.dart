abstract class TerminalSessionInterface {
  void setOutputHandler(Function(String data) handler);

  void write(String input);
  void close();
}
