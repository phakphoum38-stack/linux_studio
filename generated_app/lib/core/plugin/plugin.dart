abstract class TerminalPlugin {
  String get id;

  void onInit();
  void onData(String data);
  void onCommand(String cmd, List<int> args);
}
