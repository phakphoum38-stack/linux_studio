/// Base class for all terminal plugins.
abstract class TerminalPlugin {
  /// Unique plugin identifier.
  String get id;

  /// Called when the plugin is registered.
  void onInit();

  /// Called when terminal receives text.
  void onData(String data);

  /// Called when a terminal command is received.
  void onCommand(
    String command,
    List<int> args,
  );

  /// Called before the plugin is removed.
  void onDispose() {}
}
