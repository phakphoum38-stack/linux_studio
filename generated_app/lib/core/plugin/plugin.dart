abstract class TerminalPlugin {

  /// Unique plugin name
  String get id;


  /// Called when plugin registered
  void onInit() {}


  /// Receive terminal output stream
  void onData(
    String data,
  ) {}


  /// Receive VT100 command
  void onCommand(
    String command,
    List<int> args,
  ) {}


  /// Cleanup
  void dispose() {}
}
