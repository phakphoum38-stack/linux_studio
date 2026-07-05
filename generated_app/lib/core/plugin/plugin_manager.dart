class PluginManager {
  final List<TerminalPlugin> plugins = [];

  void register(TerminalPlugin plugin) {
    plugins.add(plugin);
    plugin.onInit();
  }

  void emitData(String data) {
    for (final p in plugins) {
      p.onData(data);
    }
  }

  void emitCommand(String cmd, List<int> args) {
    for (final p in plugins) {
      p.onCommand(cmd, args);
    }
  }

  void dispose() {
    plugins.clear();
  }
}
