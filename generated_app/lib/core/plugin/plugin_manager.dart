import 'plugin.dart';

class PluginManager {
  final List<TerminalPlugin> _plugins = [];

  List<TerminalPlugin> get plugins =>
      List.unmodifiable(_plugins);

  void register(TerminalPlugin plugin) {
    if (_plugins.contains(plugin)) {
      return;
    }

    _plugins.add(plugin);
    plugin.onInit();
  }

  void unregister(TerminalPlugin plugin) {
    if (_plugins.remove(plugin)) {
      plugin.onDispose();
    }
  }

  void emitData(String data) {
    for (final plugin in _plugins) {
      plugin.onData(data);
    }
  }

  void emitCommand(
    String command,
    List<int> args,
  ) {
    for (final plugin in _plugins) {
      plugin.onCommand(command, args);
    }
  }

  void dispose() {
    for (final plugin in _plugins) {
      plugin.onDispose();
    }

    _plugins.clear();
  }
}
